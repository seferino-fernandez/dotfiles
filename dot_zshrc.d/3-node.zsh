# Node + NPM + PNPM
# Use fnm
eval "$(fnm env --version-file-strategy=recursive --use-on-cd --corepack-enabled --shell zsh)"

# pnpm
alias npx='pnpx'

# bun completions
[ -s "/Users/seferinofernandez/.bun/_bun" ] && source "/Users/seferinofernandez/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
