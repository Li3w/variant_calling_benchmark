### Unzip vcf.gz for tabix will only accept if the gzip file is from bgzip ###

rule unzip:
    input:
        vcf_file_zip = "raw_reads/gzip/{sample_name}.vcf.gz",            
    output:
        vcf = "results/010_unzip/{sample_name}.vcf",
    log:
        "log/010_unzip/{sample_name}.log"
    shell:
        """
        (gunzip --keep -c {input.vcf_file_zip} > {output.vcf}) &> {log}
        """

### zip the vcf with bgzip ###

rule bgzip:
    input:
        vcf = rules.unzip.output['vcf']
    output:
        vcf_bgzip = "results/020_bgzip/{sample_name}.vcf.gz"
    log:
        "log/020_bgzip/{sample_name}.log"
    shell:
        """
        (bgzip -c {input.vcf} > {output.vcf_bgzip}) &> {log}
        """

### index the vcf file with tabix ###

rule index:
    input:
        vcf_bgzip = rules.bgzip.output['vcf_bgzip']
    output:
        index = "results/020_bgzip/{sample_name}.vcf.gz.tbi"
    log:
        "log/021_index/{sample_name}.log"
    shell:
        """
        (tabix -p vcf {input.vcf_bgzip})
        """

### benchmark with hap.py TO change the gold standard accordingly
### as the number of samples to test are small, will change the gold standard ref manually
### however can define a function to change the gold standard according to the test sample
  
rule benchmark:
    input:
        vcf_bgzip = rules.bgzip.output['vcf_bgzip']
    output:
        benchmark = "results/030_benchmark/{sample_name}.summary.csv"
    params:
        gold_standard = "reference/HG003_GRCh38_1_22_v4.2.1_benchmark.vcf.gz",
        false_positive = "reference/HG003_GRCh38_1_22_v4.2.1_benchmark_noinconsistent.bed",
        target = "reference/S04380110_Regions.bed",
        fasta = "/home/molecularonco/github/nccs-meth3/bundle_reference_files/hg38.fa",
        name = "results/030_benchmark/{sample_name}"
    log:
        "log/030_benchmark/{sample_name}.log"
    conda:
        "envs/environment.yaml"
    shell:
        """
        (python2 /home/molecularonco/hap.py-install/bin/hap.py {params.gold_standard} {input.vcf_bgzip} -o {params.name} -r {params.fasta} --target-regions {params.target} --false-positive {params.false_positive} --engine=vcfeval --no-decompose --no-leftshift --filter-nonref --roc GQ) &> {log}
        """

