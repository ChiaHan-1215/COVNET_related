# COVNET_related

## Goal:
Revisiting the updated COVNET dataset to validate our findings from the OAS1 paper published three years ago.

------
## File:

GTEx v9 Whole Genome sequencing vcf.gz file from 953 individuals downloaded from GTEx v9 AnVIL `/Volumes/ifs/DCEG/Branches/LTG/Prokunina/GTEx_data/GTEx_v8_genotype_vcf_and_donor_info/phg001796.v1.GTEx_v9_WGS_phased`

The extracted GT of interest genes from GTEx WGS vcf file is located: `/Volumes/ifs/DCEG/Branches/LTG/Prokunina/GTEx_data/project_COVNET_genes`

------

## Code:
`bcftools_extract_region.sh` using bcftools to extract region of interest from vcf.gz file
`vcf_GT_extract.R` extract GT of gene exons and save as .csv file

------

### Results: 
