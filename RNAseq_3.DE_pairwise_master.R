# Input: 
#     count files with 1st column gene names, 2nd column read count. 1 file for each sample. 
# Output: 
#   1. html of QC plots 
#   2. normalized counts (DE_normalized_counts.txt) 
#   3. statistical test results for significant differential expression (DE_results_all.txt)


suppressWarnings(suppressMessages(library(tidyverse)))
suppressWarnings(suppressMessages(library(magrittr)))

# put the directory
#setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
setwd("")

all_files=list.files(pattern = '.ReadsPerGene\\_noRM.txt')
names(all_files)=substr(all_files,12,15)

file_table=as_tibble(names(all_files))%>%rename(sampleName=value)
file_table$fileName=all_files

########## change this section before run
###########################
treatment_list=list(c("SK17","SK28"))
control_list=list(c("SK29","SK30"))
sample_name_list=list('E70vsE90')
###########################

for (i in seq_along(treatment_list)) {
  i=1
    treatment_files=filter(file_table,sampleName %in% treatment_list[[i]])
    treatment_files$condition="treatment"
  
    control_files=filter(file_table,sampleName %in% control_list[[i]])
    control_files$condition="control"
    
    sampleTable=bind_rows(control_files,treatment_files)
    
    sample_name=sample_name_list[[i]]
    
    write_delim(sampleTable, paste0("DE_", sample_name, "_sampleTable.txt"))
    
    rmarkdown::render('RNAseq_DE_pairwise.Rmd', output_file =  paste0("DE_", sample_name, "_pairwise_QC.html"))
}
