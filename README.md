# variant_calling_benchmark

This project contains two components:

1. A Snakemake pipeline to process VCF files and benchmark them against a truth set

2. A Python script (Jupyter notebook) to generate UpSet plots visualizing true positive (TP) variants across multiple variant callers

##  Snakemake Pipeline
1. **Unzip VCF files** (`gunzip`)
2. **Recompress with bgzip** (for tabix compatibility)
3. **Index VCFs** using `tabix`
4. **Run `hap.py`** to benchmark variant calls against the truth set

## The Jupyter notebook:
1. Parses each VCF and filters for TP variants
2. Aligns variants to the truth set by chrom/pos/ref/alt
3. Classifies variants into SNP or INDEL
4. Generates UpSet plots for visualizing overlaps

Link to article: https://www.nature.com/articles/s41598-025-97047-7
