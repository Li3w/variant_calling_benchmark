import glob
import os

FOLDER, SAMPLE_NAME = glob_wildcards("raw_reads/{folder}/{sample_name}.vcf.gz")


include: "rules/benchmark.smk"


rule all:
    input:
        expand("results/010_unzip/{sample_name}.vcf", sample_name = SAMPLE_NAME,) ,
        expand("results/020_bgzip/{sample_name}.vcf.gz", sample_name = SAMPLE_NAME,),
        expand("results/020_bgzip/{sample_name}.vcf.gz.tbi", sample_name = SAMPLE_NAME),
        expand("results/030_benchmark/{sample_name}.summary.csv", sample_name = SAMPLE_NAME)