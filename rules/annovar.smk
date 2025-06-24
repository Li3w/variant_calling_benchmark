### Unzip vcf.gz for tabix will only accept if the gzip file is from bgzip ###

rule unzip:
    input:
        vcf_file_zip = "raw_reads/gzip/{sample_name}.vcf.gz",            
    output:
        vcf = "results/010_unzip/{sample_name}.vcf",
    log:
        "log/010_unzip/{sample_name}.log"
    benchmark:
        'benchmarks/010_unzip/{sample_name}.benchmark'
    shell:
        """
        (gunzip {input.vcf_file_zip}) &> {log}
        """

### Annotate with Annovar ###

# rule annovar:
#     input:
#         avinput = rules.vcf_avinput.output['avinput']
#     output:
#         annovar_annotated = "result/030_annovar/{sample_tumor}.hg38_multianno.csv"
#     params:
#         humandb = config['resources']['humandb'],
#         outfile = "result/030_annovar/{sample_tumor}"
#     resources:
#         num_threads = config['threads']['annovar'],
#     log:
#         "log/030_annovar/{sample_tumor}.log"
#     benchmark:
#         'benchmarks/030_annovar/{sample_tumor}.benchmark'
#     shell:
#         """
#         (table_annovar.pl {input.avinput} {params.humandb} --buildver hg38 --outfile {params.outfile} --thread {resources.num_threads} --remove --polish --csvout --protocol refGene,ljb26_all,clinvar_20221231,revel,gnomad312_genome --operation g,f,f,f,f) &> {log}
#         """

