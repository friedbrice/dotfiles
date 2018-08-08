import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig

main = xmonad =<< xmobar (additionalKeysP (additionalKeys cnfg addk) addp)

modm = mod4Mask

cnfg = defaultConfig
    { modMask = modm
    , terminal = "urxvt"
    }

addk =
    [ ((modm, xK_p), spawn "j4-dmenu-desktop")
    ]

addp =
    [ ("<XF86MonBrightnessUp>"  , spawn "backlight raise 500"        )
    , ("<XF86MonBrightnessDown>", spawn "backlight lower 500"        )
    , ("<XF86AudioMute>"        , spawn "amixer -q set Master toggle"   )
    , ("<XF86AudioLowerVolume>" , spawn "amixer -q set Master 5- unmute")
    , ("<XF86AudioRaiseVolume>" , spawn "amixer -q set Master 5+ unmute")
    ]
