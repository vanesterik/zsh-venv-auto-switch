#!/usr/bin/env zsh
#
# Tests for zsh-venv-auto-switch. Run them with `zsh test.zsh`.
#
# Each test runs in its own subshell, in a temporary tree of projects:
#
#   a/              .venv
#   a/src/deep/
#   a/nested/       .venv of its own
#   a/nested/src/
#   b/              .venv
#   plain/          no .venv

plugin="${0:A:h}/zsh-venv-auto-switch.zsh"

# Resolve the temporary directory's symlinks (/var is /private/var on macOS),
# so the paths below match $PWD after a cd
tmp="$(mktemp -d)"
tmp="${tmp:A}"
trap 'rm -rf "$tmp"' EXIT

# A stand-in for `python -m venv`: activate sets VIRTUAL_ENV, counts
# activations and defines deactivate, like the real script
make_venv() {
    mkdir -p "$1/.venv/bin"
    cat > "$1/.venv/bin/activate" <<EOF
VIRTUAL_ENV="$1/.venv"
(( activations++ ))
deactivate() { unset VIRTUAL_ENV; unset -f deactivate; }
EOF
}

make_venv "$tmp/a"
make_venv "$tmp/a/nested"
make_venv "$tmp/b"
mkdir -p "$tmp/a/src/deep" "$tmp/a/nested/src" "$tmp/plain"

# Fail the test, which exits its subshell, unless VIRTUAL_ENV is $1 (or unset for "")
assert_venv() {
    if [[ "${VIRTUAL_ENV-}" != "$1" ]]; then
        print -u2 "    expected VIRTUAL_ENV ${1:-unset}, got ${VIRTUAL_ENV:-unset}"
        exit 1
    fi
}

test_activates_in_project_root() {
    source "$plugin"
    cd a
    assert_venv "$tmp/a/.venv"
}

test_keeps_venv_in_subdirectories() {
    source "$plugin"
    cd a/src/deep
    assert_venv "$tmp/a/.venv"
    cd ..
    assert_venv "$tmp/a/.venv"
}

test_activates_only_once_per_project() {
    source "$plugin"
    cd a
    cd src
    cd ..
    if (( activations != 1 )); then
        print -u2 "    expected 1 activation, got $activations"
        exit 1
    fi
}

test_switches_between_projects() {
    source "$plugin"
    cd a
    cd ../b
    assert_venv "$tmp/b/.venv"
}

test_uses_nearest_venv_in_nested_projects() {
    source "$plugin"
    cd a/nested/src
    assert_venv "$tmp/a/nested/.venv"
    cd ../..
    assert_venv "$tmp/a/.venv"
}

test_deactivates_outside_projects() {
    source "$plugin"
    cd a
    cd ../plain
    assert_venv ""
}

test_deactivates_at_filesystem_root() {
    source "$plugin"
    cd a
    cd /
    assert_venv ""
}

test_activates_when_shell_starts_in_subdirectory() {
    cd a/src
    source "$plugin"
    assert_venv "$tmp/a/.venv"
}

# A venv activated in a parent shell: VIRTUAL_ENV is inherited, deactivate isn't
test_leaves_venv_it_cannot_deactivate() {
    VIRTUAL_ENV=/elsewhere/.venv
    source "$plugin"
    cd plain
    assert_venv /elsewhere/.venv
}

test_replaces_venv_it_cannot_deactivate_in_project() {
    VIRTUAL_ENV=/elsewhere/.venv
    source "$plugin"
    cd a
    assert_venv "$tmp/a/.venv"
}

failures=0
for test in ${(ok)functions[(I)test_*]}; do
    if ( unset VIRTUAL_ENV; activations=0; cd "$tmp" && $test ); then
        print "ok   $test"
    else
        print "FAIL $test"
        (( failures++ ))
    fi
done

if (( failures )); then
    print "\n$failures failed"
    exit 1
fi
print "\nall passed"
