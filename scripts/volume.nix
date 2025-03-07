{ pkgs }:

# Increment, decrement, or mute the volume using Pipewire and send a notification
pkgs.writeShellScriptBin "volume" ''
  # Ensure volume is unmuted when changing volume
  if [ "$1" != "mute" ]; then
    ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
  fi

  # Adjust volume based on the argument
  case $1 in
    up)
      ${pkgs.wireplumber}/bin/wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 2%+
      ;;
    down)
      ${pkgs.wireplumber}/bin/wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 2%-
      ;;
    mute)
      ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      ;;
  esac

  VOLUME=$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')


  send_notification() {
    TEXT="Currently at ''${VOLUME}%"
    if [ "$VOLUME" -lt 33 ]; then
      ICON="low"
    elif [ "$VOLUME" -lt 66 ]; then
      ICON="medium"
    else
      ICON="high"
    fi

    if [ "$1" = "mute" ]; then
      ICON="mute"
      TEXT="Currently muted"
    fi

    ${pkgs.dunst}/bin/dunstify -a "Volume" -r 9993 -h int:value:"$VOLUME" -i "volume-$ICON" "Volume" "$TEXT" -t 2000
  }

  # Send the appropriate notification based on the mute state
  if [ "$1" = "mute" ]; then
    if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED"; then
      send_notification mute
    else
      send_notification
    fi
  else
    send_notification
  fi
''
