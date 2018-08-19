import Graphics.X11.ExtraTypes.XF86
import XMonad                             hiding (keys)
import XMonad.Hooks.DynamicLog            (xmobar)
import XMonad.Layout.BinarySpacePartition (emptyBSP)
import XMonad.Layout.Grid                 (Grid(Grid))
import XMonad.StackSet                    (RationalRect(RationalRect))
import XMonad.Util.EZConfig               (additionalKeys)
import qualified XMonad.Util.NamedScratchpad as NS

main = xmonad =<< xmobar (additionalKeys conf keys)

modM = mod4Mask
modS = modM .|. shiftMask
modN = noModMask
term = "urxvt"
file = "pcmanfm"
termNS = term ++ "-scratchpad"
fileNS = file ++ "-scratchpad"

keys =
    [ ((modM, xK_p), spawn "j4-dmenu-desktop")
    , ((modM, xK_Up), NS.namedScratchpadAction pads termNS)
    , ((modM, xK_Left), NS.namedScratchpadAction pads fileNS)
    , ((modN, xF86XK_MonBrightnessUp), spawn "backlight raise 50")
    , ((modN, xF86XK_MonBrightnessDown), spawn "backlight lower 50")
    , ((modN, xF86XK_AudioMute), spawn "amixer -q set Master toggle")
    , ((modN, xF86XK_AudioLowerVolume), spawn "amixer -q set Master 5- unmute")
    , ((modN, xF86XK_AudioRaiseVolume), spawn "amixer -q set Master 5+ unmute")
    ]

conf = def
    { modMask            = modM
    , terminal           = term
    , borderWidth        = 2
    , normalBorderColor  = "grey"
    , focusedBorderColor = "#3DAEE9"
    , workspaces         = ["1", "2", "3", "4", "5", "6", "NSP"]
    , startupHook        = spawn "feh --bg-scale \"$HOME/.wallpaper\""
    , manageHook         = manageHook def
                       <+> NS.namedScratchpadManageHook pads
    , layoutHook         = layoutHook def ||| emptyBSP ||| Grid
    }

pads =
    [ NS.NS
        { NS.name  = termNS
        , NS.cmd   = term ++ " -name " ++ termNS
        , NS.query = resource =? termNS
        , NS.hook  = NS.customFloating $ RationalRect 0 0.02 1 0.35
        }
    , NS.NS
        { NS.name  = fileNS
        , NS.cmd   = file ++ " --name " ++ fileNS
        , NS.query = resource =? fileNS
        , NS.hook  = NS.customFloating $ RationalRect 0 0.02 0.35 1
        }
    ]
