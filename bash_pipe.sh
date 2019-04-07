#Step 0: Convert bash script into executable file
chmod +x $0

#Step 1: Create script variables
bwa_idx=$1
bwa_1=$2
bwa_2=$3
samtools_ref=$4


#Step 2: Install packages needed
#sudo apt-get install bwa
#sudo apt-get install samtools
#sudo apt-get install bcftools


#Step 3: Call Variants from seed lengths 1 to 102 for bwa_1 and bwa_2 files
for i in {1..102}; do 
bwa mem -k $i $bwa_idx $bwa_1 $bwa_2  > mt_k$i.sam; 
samtools sort mt_k$i.sam > mt_k$i-s.sam; 
samtools mpileup -Ou -f $samtools_ref mt_k$i-s.sam | bcftools call -vmO v -o mt_k$i.vcf; 
grep -v "^#" mt_k$i.vcf | cut -f 2 > cut_mt_k$i.vcf;
done

#Step 4: Create variant list of unique positions from combined VCF data
cat cut_mt_k*.vcf > raw_data.vcf
sort -u combinedvcf_pos.vcf > variant_list.vcf

#Step 5: Remove intermediate files
for i in {1..102}; do 
rm mt_k$i.sam;
rm mt_k$i-s.sam;
rm mt_k$i.vcf;
rm cut_mt_k$i.vcf;
done

#Repeat Steps 3 to 5 by indexing bwa_1 and bwa_2 files individually
for i in {1..102}; do 
bwa mem -k $i $bwa_idx $bwa_1  > mt_k$i.sam; 
samtools sort mt_k$i.sam > mt_k$i-s.sam; 
samtools mpileup -Ou -f $samtools_ref mt_k$i-s.sam | bcftools call -vmO v -o mt_k$i.vcf; 
grep -v "^#" mt_k$i.vcf | cut -f 2 > cut_mt_k$i.vcf;
done
cat cut_mt_k*.vcf > raw_data_bwa_1.vcf
sort -u raw_data_bwa_1.vcf > variant_list_bwa_1.vcf
for i in {1..102}; do 
rm mt_k$i.sam;
rm mt_k$i-s.sam;
rm mt_k$i.vcf;
rm cut_mt_k$i.vcf;
done

for i in {1..102}; do 
bwa mem -k $i $bwa_idx $bwa_2  > mt_k$i.sam; 
samtools sort mt_k$i.sam > mt_k$i-s.sam; 
samtools mpileup -Ou -f $samtools_ref mt_k$i-s.sam | bcftools call -vmO v -o mt_k$i.vcf; 
grep -v "^#" mt_k$i.vcf | cut -f 2 > cut_mt_k$i.vcf;
done
cat cut_mt_k*.vcf > raw_data_bwa_2.vcf
sort -u raw_data_bwa_2.vcf > variant_list_bwa_2.vcf
for i in {1..102}; do 
rm mt_k$i.sam;
rm mt_k$i-s.sam;
rm mt_k$i.vcf;
rm cut_mt_k$i.vcf;
done
