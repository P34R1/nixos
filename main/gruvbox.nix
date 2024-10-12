{
  # https://github.com/tinted-theming/base24/blob/main/base24schema.json
  colorScheme = {
    name = "Gruvbox dark, medium";
    author = "Gabriel Fontes (https://github.com/Misterio77)";
    # https://camo.githubusercontent.com/3dfae3155f4ad996e105584d9ff884ad9b8a93c20b4c2eaad0ce226c680e58e2/687474703a2f2f692e696d6775722e636f6d2f776136363678672e706e67
    palette = {
      # Shades (black, gray, white)
      base00 = "282828"; # ----                 Background. Default Background
      base01 = "3c3836"; # ---                  Black. Lighter Background(Used for status bars)
      base02 = "504945"; # --                   Bright Black. Selection Background
      base03 = "665c54"; # -                    Comments, Invisibles, Line Highlighting.
      base04 = "bdae93"; # +                    Dark Foreground (Used for status bars).
      base05 = "d5c4a1"; # ++                   Foreground. Default Foreground, Caret, Delimiters, Operators
      base06 = "ebdbb2"; # +++                  White. Light Foreground (Not often used)
      base07 = "fbf1c7"; # ++++                 Bright White. Lightest Foreground (Not often used)

      # Colours
      base08 = "cc241d"; # red                  Red. Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
      base09 = "d79921"; # yellow               Yellow. Integers, Boolean, Constants, XML Attributes, Markup Link Url
      base0A = "d65d0e"; # orange               Classes, Markup Bold, Search Text Background.
      base0B = "98971a"; # green                Green. Strings, Inherited Class, Markup Code, Diff Inserted
      base0C = "6896da"; # aqua/cyan            Cyan. Support, Regular Expressions, Escape Characters, Markup Quotes
      base0D = "458588"; # blue                 Blue. Functions, Methods, Attribute IDs, Headings
      base0E = "b16286"; # purple               Purple. Keywords, Storage, Selector, Markup Italic, Diff Changed
      base0F = "fe8019"; # brown                Deprecated.

      # Bright Colours
      base10 = "32302f"; # darker background
      base11 = "1d2021"; # darkest background
      base12 = "fb4934"; # bright red
      base13 = "fabd2f"; # bright yellow
      base14 = "b8bb26"; # bright green
      base15 = "8ec07c"; # brights aqua/cyan
      base16 = "83a598"; # bright blue
      base17 = "d3869b"; # bright purple
    };
  };
}
