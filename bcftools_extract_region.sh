# extract region
# bcftools v1.2

ml bcftools/

bcftools view -r chr15:78548269-78642320 GTEx_Analysis_2021-02-11_v9_WholeGenomeSeq_953Indiv.vcf.gz -Oz -o set1.vcf.gz
