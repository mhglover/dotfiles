# History settings

# Allow use to re-edit a faild history substitution.
shopt -s histreedit
# History expansions will not be verified before execution.
shopt -u histverify

# save all lines of a multiple-line command in the same history entry. This allows easy re-editing of multi-line commands.
shopt -s cmdhist

# Entries beginning with space aren't added into history, and duplicate
# entries will be erased (leaving the most recent entry).
export HISTCONTROL="ignorespace:erasedups"
# Give history timestamps.
export HISTTIMEFORMAT="[%F %T] "
# Lots o' history.
export HISTSIZE=10000
export HISTFILESIZE=10000

# Easily re-execute the last history command.
alias r="fc -s"
