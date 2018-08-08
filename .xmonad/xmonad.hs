import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig

main = xmonad =<< xmobar (additionalKeys cnfg addk)

modm = mod4Mask

cnfg = defaultConfig
    { modMask = modm
    , terminal = "urxvt"
    }

addk =
    [ ((modm, xK_p), spawn "j4-dmenu-desktop")
    ]
