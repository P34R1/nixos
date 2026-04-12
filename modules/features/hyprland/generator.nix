{
  self,
  inputs,
  lib,
  ...
}:

{
  flake.wrappers.hyprland = inputs.wrapper-modules.lib.wrapModule (
    {
      config,
      wlib,
      lib,
      pkgs,
      ...
    }:
    let
      conf = pkgs.writeText "hyprland.conf" (self.lib.generators.toHyprconf { attrs = config.settings; });
    in
    {
      options.settings = lib.mkOption { };
      config = {
        package = pkgs.hyprland;

        drv.installPhase = ''
          runHook preInstall
          XDG_RUNTIME_DIR=/tmp ${lib.getExe config.package} --verify-config --config ${conf}
          runHook postInstall
        '';

        flags = {
          "--config" = "${conf}";
        };
      };
    }
  );

  # FULL CREDIT TO
  # https://github.com/nix-community/home-manager/blob/master/modules/services/window-managers/hyprland.nix
  flake.lib.generators.toHyprconf =
    {
      attrs,
      indentLevel ? 0,
      importantPrefixes ? [ "$" ],
    }:
    let
      inherit (lib)
        all
        concatMapStringsSep
        concatStrings
        concatStringsSep
        filterAttrs
        foldl
        generators
        hasPrefix
        isAttrs
        isList
        mapAttrsToList
        replicate
        ;

      initialIndent = concatStrings (replicate indentLevel "  ");

      toHyprconf' =
        indent: attrs:
        let
          sections = filterAttrs (n: v: isAttrs v || (isList v && all isAttrs v)) attrs;

          mkSection =
            n: attrs:
            if lib.isList attrs then
              (concatMapStringsSep "\n" (a: mkSection n a) attrs)
            else
              ''
                ${indent}${n} {
                ${toHyprconf' "  ${indent}" attrs}${indent}}
              '';

          mkFields = generators.toKeyValue {
            listsAsDuplicateKeys = true;
            inherit indent;
          };

          allFields = filterAttrs (n: v: !(isAttrs v || (isList v && all isAttrs v))) attrs;

          isImportantField =
            n: _: foldl (acc: prev: if hasPrefix prev n then true else acc) false importantPrefixes;

          importantFields = filterAttrs isImportantField allFields;

          fields = builtins.removeAttrs allFields (mapAttrsToList (n: _: n) importantFields);
        in
        mkFields importantFields
        + concatStringsSep "\n" (mapAttrsToList mkSection sections)
        + mkFields fields;
    in
    toHyprconf' initialIndent attrs;
}
