# JSON format
This file describes the foramt of the following 3 json files.
## posd
- Data of microbiome Resistance according to different rooms and sites.
- For $Room_X/Ward_X/MDRO_X naming, do the following:
    - For rooms, name it as "Room_X", where X is the index.
    - For Standard Wards, name it as "Ward_X", where X is the index.
    - For MDRO wards, name it as "MDRO_X", where X is the index.
- For $Site/Site_X, do the following:
    - If it is a room, DO NOT add any index. Just use the name indicated in the dataframe
    - If it is a Ward(Standard or MDRO), add index when it is related to a bed. For example, Bed_Rail_X, Bedside_Locker_X. DO NOT add any index when it is not bed related. For example, Sink_Trap, Aerator.
    - If it is not bed related but still has several samples, for example, 2 sink traps, we always take the first one and DO NOT add any index.
## sped
- Data of microbiome Existence according to specie and strain.
- For the strain's list, name according to posd's $Room_X/Ward_X/MDRO_X.
## timepoint
- 1: timepoint 1
- 2: timepoint 2
- 3: timepoint 1 & 2