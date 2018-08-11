import Graphics.X11.ExtraTypes.XF86
import XMonad hiding (keys)
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig

main = xmonad =<< xmobar (additionalKeys conf keys)

keys =
    [ ((mod4Mask              , xK_p                    ), spawn "j4-dmenu-desktop"              )
    , ((mod4Mask              , xK_q                    ), kill                                  )
    , ((mod4Mask .|. shiftMask, xK_c                    ), pure ()                               )
    , ((mod4Mask .|. shiftMask, xK_p                    ), pure ()                               )
    , ((noModMask             , xF86XK_MonBrightnessUp  ), spawn "backlight raise 50"            )
    , ((noModMask             , xF86XK_MonBrightnessDown), spawn "backlight lower 50"            )
    , ((noModMask             , xF86XK_AudioMute        ), spawn "amixer -q set Master toggle"   )
    , ((noModMask             , xF86XK_AudioLowerVolume ), spawn "amixer -q set Master 5- unmute")
    , ((noModMask             , xF86XK_AudioRaiseVolume ), spawn "amixer -q set Master 5+ unmute")
    ]

conf = def
    { modMask = mod4Mask
    , terminal = "urxvt"
    , workspaces = ["1", "2", "3", "4", "5", "6"]
    , startupHook = spawn "feh --bg-scale \"$HOME/.wallpaper\""
    }
