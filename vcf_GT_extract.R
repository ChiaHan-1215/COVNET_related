#########################################################
# geting GTEX ID and target SNPs from subsetted vcf file#
#########################################################

library(vcfR)
library(tidyr)
library(reshape2)
library(stringr) 
library(textclean)
library(xlsx)
library(dplyr)

# load gene location
spl <- read.csv('/Volumes/ifs/DCEG/Branches/LTG/Prokunina/COVNET/target_genes_exon_coordinates.csv')

# list of target vcf
gene_ls <- list.files('/Volumes/ifs/DCEG/Branches/LTG/Prokunina/GTEx_data/project_COVNET_genes',full.names = T,pattern = '.gz')


# load vcf 


for (i in gene_ls){
  # i <- "/Volumes/ifs/DCEG/Branches/LTG/Prokunina/GTEx_data/project_COVNET_genes/CAV1_region.vcf.gz"
  vcf.file.tmp <- read.vcfR(i)
  genesymbol <- gsub('/Volumes/ifs/DCEG/Branches/LTG/Prokunina/GTEx_data/project_COVNET_genes/|_region.vcf.gz','',i)
  spl_sub <- spl %>% filter(gene_name ==genesymbol)
  
  
  chroms <- getCHROM(vcf.file.tmp)
  poss <- getPOS(vcf.file.tmp)
  
  idx <- unlist(
    lapply(1:nrow(spl_sub), function(j)
      which(chroms == spl_sub$seqnames[j] & poss >= spl_sub$start[j] & poss <= spl_sub$end[j])
    )
  )
  
  idx <- unique(idx)
  vcf.file.set <- vcf.file.tmp[idx, ]
  
  # get and format genotypes, set "return.alleles = TRUE" can switch 0|1 to A|G
  vcf_genotypes.tmp <- extract.gt(
    vcf.file.set,
    element = "GT",
    mask = FALSE,
    as.numeric = FALSE,
    return.alleles = TRUE,
    IDtoRowNames = TRUE,
    extract = TRUE,
    convertNA = TRUE
  )
  
  # transform dataframe row/column
  geno_df.tmp <- as.data.frame(t(vcf_genotypes.tmp))
  
  geno_df.tmp <-geno_df.tmp %>% 
    tibble::rownames_to_column(var = "id") %>%
    relocate(id, .before = 1)
  
  # remove "/" or "|"  between genotype
  geno_df.tmp <- data.frame(lapply(geno_df.tmp, function(x){ gsub("\\/", " ", x)}))
  
  
  # to remove the last -0003 etc from GTEx_ID
  # remove the last “-XXXX” chunk (hyphen plus any non-hyphen chars to end)
  geno_df.tmp$id <- sub("-[^-]+$", "", geno_df.tmp$id)
  
  # remove _1 _2...
  names(geno_df.tmp) <- gsub('_[0-9]+$','',names(geno_df.tmp))
  
  # save
  
  write.table(geno_df.tmp,paste0('/Volumes/ifs/DCEG/Branches/LTG/Prokunina/GTEx_data/project_COVNET_genes/',genesymbol,'_GT_.csv'),col.names = T,row.names = F,sep = ',',quote = F)
  rm(geno_df.tmp,vcf.file.tmp,vcf.file.set)
  
}



