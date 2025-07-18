fx_version 'cerulean'
game 'gta5'

use_experimental_fxv2_oal 'yes'
lua54 'yes'

-- Audio files
files {
    'audiodata/nd_police.dat54.rel',
    'audiodirectory/nd_police.awc',
    'data/**'
}

-- Data files
data_file 'DLC_ITYP_REQUEST' 'stream/cuffs_main.ytyp'
data_file 'AUDIO_WAVEPACK' 'audiodirectory'
data_file 'AUDIO_SOUNDDATA' 'audiodata/nd_police.dat'

-- Dependencies
shared_scripts {
    '@ox_lib/init.lua'
}

-- Server-side scripts
server_scripts {
    'server/*.lua'
}

-- Client-side scripts
client_scripts {
    'client/*.lua'
}