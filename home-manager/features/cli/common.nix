{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # File operations & search
    ripgrep       # Better grep
    fd            # Better find
    bat           # Better cat with syntax highlighting
    unzip         # Archive utility

    # System monitoring
    htop          # Interactive process viewer
    btop          # Better top with graphs
    fastfetch     # Fast system info display

    # Navigation & utilities
    fzf           # Fuzzy finder
    tldr          # Simplified man pages

    # Network utilities
    wget          # Download files
    curl          # Transfer data with URLs

    # Nix utilities
    nix-tree      # Explore nix store dependencies

    # Shell & terminal utilities
    oh-my-posh    # Shell prompt theme engine

    # Utilities
    bc            # Command-line calculator
    jq            # JSON processor
  ];
}
