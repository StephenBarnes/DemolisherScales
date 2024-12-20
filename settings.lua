data:extend({
    {
        type = "double-setting",
        name = "DemolisherScales-scale-drop-multiplier",
        order = "1",
        setting_type = "startup",
        default_value = 1.0,
        minimum_value = 0.0,
    },
    {
        type = "bool-setting",
        name = "DemolisherScales-mark-deconstruction",
        order = "2",
        setting_type = "runtime-global",
        default_value = true,
    },
    {
        type = "int-setting",
        name = "DemolisherScales-egg-spoil-seconds-override",
        order = "2",
        setting_type = "startup",
        default_value = 4 * 60, -- 4 minutes.
        minimum_value = 0,
    },
})