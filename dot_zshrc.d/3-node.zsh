# Node + NPM + PNPM
# Use fnm
eval "$(fnm env --version-file-strategy=recursive --use-on-cd --corepack-enabled --shell zsh)"

# pnpm
alias npx='pnpx'

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
