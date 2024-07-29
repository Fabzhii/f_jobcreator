
-- Ox Inventory Items
return {
    ['handcuff'] = {
        label = 'Handschellen',
        weight = 450,
        client = {
            export = 'f_jobmaker.handcuff',
        },
    },
    ['ziptie'] = {
        label = 'Kabelbinder',
        weight = 250,
        client = {
            export = 'f_jobmaker.ziptie',
        },
    },
    ['handcuff_key'] = {
        label = 'Handschellen Schlüssel',
        weight = 150,
        client = {
            export = 'f_jobmaker.release',
        },
    },
    ['ziptie_key'] = {
        label = 'Kabelbinder Schere',
        weight = 750,
        client = {
            export = 'f_jobmaker.release',
        },
    },
    ['dietrich'] = {
        label = 'Dietrich',
        weight = 750,
        client = {
            export = 'f_jobmaker.open_vehicle',
        },
    },
    ['tire_kit'] = {
        label = 'Reperaturkasten Reifen',
        weight = 2500,
        client = {
            export = 'f_jobmaker.repair_vehicle_wheels',
        },
    },
    ['body_kit'] = {
        label = 'Reperaturkasten Karosserie',
        weight = 5500,
        client = {
            export = 'f_jobmaker.repair_vehicle_body',
        },
    },
    ['engine_kit'] = {
        label = 'Reperaturkasten Motor',
        weight = 4500,
        client = {
            export = 'f_jobmaker.repair_vehicle_engine',
        },
    },
}
