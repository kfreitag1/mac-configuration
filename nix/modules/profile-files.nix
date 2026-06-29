{ config, lib, ... }:
let
  cfg = config.my.profileFiles;
  user = config.system.primaryUser;
  home = config.users.users.${user}.home;

  filesIn = dir: prefix:
    lib.flatten (
      lib.mapAttrsToList
        (name: type:
          let
            path = dir + "/${name}";
            rel = if prefix == "" then name else "${prefix}/${name}";
          in
          if lib.elem name cfg.ignoredNames then
            [ ]
          else if type == "regular" || type == "symlink" then
            [{ inherit path rel; }]
          else if type == "directory" then
            filesIn path rel
          else
            [ ]
        )
        (builtins.readDir dir)
    );

  discoveredFiles =
    if cfg.sourceDir == null then
      { }
    else
      lib.listToAttrs (
        map
          (file: {
            name = file.rel;
            value =
              if cfg.linkSourceDir == null then
                file.path
              else
                "${cfg.linkSourceDir}/${file.rel}";
          })
          (filesIn cfg.sourceDir "")
      );

  files = discoveredFiles // cfg.files;

  linkFile = rel: source:
    let
      target = "${home}/.config/${rel}";
    in
    ''
      target=${lib.escapeShellArg target}
      source=${lib.escapeShellArg (toString source)}
      if [ ! -e "$source" ]; then
        echo "my.profileFiles: source does not exist for $target: $source" >&2
        exit 1
      fi
      /usr/bin/install -d -m 0755 -o ${lib.escapeShellArg user} -g staff "$(/usr/bin/dirname "$target")"
      /bin/rm -f "$target"
      /bin/ln -s "$source" "$target"
      /usr/sbin/chown -h ${lib.escapeShellArg user}:staff "$target"
    '';
in
{
  options.my.profileFiles = {
    sourceDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Directory whose files should be linked into ~/.config, preserving paths.
        For example, personal/claude/settings.json becomes
        ~/.config/claude/settings.json.
      '';
    };

    linkSourceDir = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Mutable checkout directory to link discovered files from.

        sourceDir is still used for pure flake-time discovery, but path values
        in flakes point at /nix/store copies. Set this to the matching checkout
        directory when the resulting ~/.config symlinks should point back to
        editable files in this repository.
      '';
    };

    ignoredNames = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ".DS_Store" ];
      description = "File or directory names to ignore while discovering profile files.";
    };

    files = lib.mkOption {
      type = lib.types.attrsOf (lib.types.oneOf [ lib.types.path lib.types.str ]);
      default = { };
      description = ''
        Extra profile-specific files to link into ~/.config. Keys are paths
        relative to ~/.config; values are source files in this flake or absolute
        mutable checkout paths.
      '';
    };
  };

  config = lib.mkIf (files != { }) {
    system.activationScripts.postActivation.text = lib.concatStringsSep "\n" (
      lib.mapAttrsToList linkFile files
    );
  };
}
