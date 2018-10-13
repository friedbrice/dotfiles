import XMonad hiding (keys)
import XMonad.Hooks.DynamicLog (xmobar)
import XMonad.StackSet (RationalRect(RationalRect))
import XMonad.Util.EZConfig (additionalKeys)

import qualified Graphics.X11.ExtraTypes.XF86 as ET
import qualified XMonad.Util.NamedScratchpad as NS

main = xmonad =<< xmobar (additionalKeys conf keys)

term = "urxvt"
file = "pcmanfm"
iweb = "chromium"
termNS = term ++ "-scratchpad"
fileNS = file ++ "-scratchpad"
iwebNS = iweb ++ "-scratchpad"

keys =
    [ ((mod4Mask, xK_p), spawn "j4-dmenu-desktop")
    -- , ((mod4Mask, xK_c), spawn "xclip -out | xclip -selection clipboard")
    -- , ((mod4Mask, xK_v), spawn "sleep 0.1 && xdotool type --clearmodifiers --delay 0 \"`xclip -out -selection clipboard`\"")
    , ((mod4Mask, xK_Up), NS.namedScratchpadAction pads termNS)
    , ((mod4Mask, xK_Left), NS.namedScratchpadAction pads fileNS)
    , ((noModMask, xK_Print), spawn "lximage-qt --screenshot")
    , ((noModMask, ET.xF86XK_MonBrightnessUp), spawn "backlight raise 50")
    , ((noModMask, ET.xF86XK_MonBrightnessDown), spawn "backlight lower 50")
    , ((noModMask, ET.xF86XK_AudioMute), spawn "pactl set-sink-mute 0 toggle")
    , ((noModMask, ET.xF86XK_AudioLowerVolume), spawn "pactl set-sink-mute 0 false; pactl set-sink-volume 0 -5%")
    , ((noModMask, ET.xF86XK_AudioRaiseVolume), spawn "pactl set-sink-mute 0 false; pactl set-sink-volume 0 +5%")
    , ((noModMask, ET.xF86XK_AudioMicMute), spawn "pactl set-source-mute 1 toggle")
    , ((noModMask, ET.xF86XK_Display), spawn "arandr")
    -- , ((noModMask, ET.xF86XK_WLAN), spawn "sudo netctl-auto stop wlp2s0 && sudo netctl-auto start wlp2s0")
    -- , ((noModMask, ET.xF86XK_Tools), pure ())
    -- , ((noModMask, ET.xF86XK_Bluetooth), pure ())
    ]

conf = def
    { modMask            = mod4Mask
    , terminal           = term
    , borderWidth        = 2
    , normalBorderColor  = "grey"
    , focusedBorderColor = "#3DAEE9"
    , workspaces         = ["1", "2", "3", "4", "5", "6", "NSP"]
    , startupHook        = spawn "feh --bg-scale \"$HOME/.wallpaper\""
    , manageHook         = manageHook def
                       <+> NS.namedScratchpadManageHook pads
    }

pads =
    [ NS.NS
        { NS.name  = termNS
        , NS.cmd   = term ++ " -name " ++ termNS
        , NS.query = resource =? termNS
        , NS.hook  = NS.customFloating $ RationalRect 0.2 0.1 0.6 0.6
        }
    , NS.NS
        { NS.name  = fileNS
        , NS.cmd   = file ++ " --name " ++ fileNS
        , NS.query = resource =? fileNS
        , NS.hook  = NS.customFloating $ RationalRect 0.1 0.3 0.6 0.6
        }
    ]
