library(tidyverse)

dat <- read.table("strain_cluster_summary.tsv", head=T, stringsAsFactors = F) %>% 
    select(Species, Strain=strain, Room_type, Cubicle_room, Sample_type, bed_number, timept, Antibiotics) %>% 
    mutate(Cubicle_room=ifelse(Room_type=="MDRO_wards", str_replace(Cubicle_room, "Ward", "MDRO"), Cubicle_room)) %>% 
    select(-Room_type) 

dat[dat$Sample_type == "Bed_Rail" & !is.na(dat$bed_number), "Sample_type"] <- apply(dat[dat$Sample_type == "Bed_Rail" & !is.na(dat$bed_number), c("Sample_type", "bed_number")],1,paste0,collapse="_")


# sped.json

sped <- list()
for(species in unique(dat$Species)){
    sped[[species]] <- list()
    strains <- filter(dat, Species==species) %>% 
        pull(Strain) %>% unique
    for(strain in strains) {
        loc <- filter(dat, Species==species, Strain==strain) %>% pull(Cubicle_room)
        sped[[species]][[strain]] <- unique(loc)
    }
}
jsonlite::toJSON(sped, pretty = T) %>% write("sped.json")

# posd
posd <- list()
for(room in unique(dat$Cubicle_room)){
    posd[[room]] <- list()
    sites <- filter(dat, Cubicle_room==room) %>% 
        pull(Sample_type) %>% unique
    for(site in sites) {
        species <- filter(dat, Cubicle_room==room, Sample_type==site) %>% 
            pull(Species) %>% unique
        if(length(species)==0) next
        posd[[room]][[site]] <- list()
        for(sp in species){
            strains <- filter(dat, Cubicle_room==room, Sample_type==site, Species==sp) %>% 
                pull(Strain) %>% unique
            if(length(strains)==0) next
            posd[[room]][[site]][[sp]] <- list()
            for(strain in strains){
                tmp <- filter(dat, Species==sp, Strain==strain) %>% 
                    pull(Antibiotics) %>% unique()
                if(length(tmp)==0) next
                posd[[room]][[site]][[sp]][[strain]] <- tmp
            }
        }
    }
}
jsonlite::toJSON(posd,  pretty = T) %>% write("posd.json")


# timepoint
timepoint <- list()
for(room in unique(dat$Cubicle_room)){
    timepoint[[room]] <- list()
    sites <- filter(dat, Cubicle_room==room) %>% 
        pull(Sample_type) %>% unique
    for(site in sites) {
        species <- filter(dat, Cubicle_room==room, Sample_type==site) %>% 
            pull(Species) %>% unique
        if(length(species)==0) next
        timepoint[[room]][[site]] <- list()
        for(sp in species){
            strains <- filter(dat, Cubicle_room==room, Sample_type==site, Species==sp) %>% 
                pull(Strain) %>% unique
            if(length(strains)==0) next
            timepoint[[room]][[site]][[sp]] <- list()
            for(strain in strains){
                tmp <- filter(dat, Cubicle_room==room, Sample_type==site, Species==sp, Strain==strain) %>% 
                    pull(timept) %>% unique()
                if(length(tmp)==0) next
                if(length(tmp)==2) tmp <- 3
                timepoint[[room]][[site]][[sp]][[strain]] <- tmp
            }
        }
    }
}
jsonlite::toJSON(timepoint, auto_unbox = T, pretty = T) %>% write("timepoint.json")


    
