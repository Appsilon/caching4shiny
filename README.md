# Caching strategies applied to a Manhattan plot

Showcase different caching tools and strategies applied to the Bioinformatics Manhattan plot.

## Manhattan plot
A Manhattan plot is a type of scatter plot used in bioinformatics, particularly in genome-wide association studies (GWAS),
to display the association between genetic variants and a particular trait or disease.
Each point on the plot represents a single nucleotide polymorphism (SNP),
with its position along the genome on the x-axis and its significance (usually as the negative logarithm of the p-value)
on the y-axis.
This visualization helps identify regions of the genome that are significantly associated with the trait being studied.

Manhattan plots are crucial for interpreting GWAS results because they can highlight genetic loci that may contribute
to complex diseases.
The datasets involved in GWAS are typically massive, often containing millions of SNPs and data from thousands
of individuals, making effective visualization tools like Manhattan plots essential for meaningful analysis.


### Generating data 
The function generate_gwas_data creates a dataset with a specified number of genetic variants (SNPs),
randomly assigning each SNP a chromosome (CHR), a base pair position (BP), and a p-value (P).
The SNP identifiers are simulated by generating random numbers prefixed with "rs".
The random assignment of these values mimics the distribution of SNPs across the genome and their corresponding
significance levels, which are essential for creating a representative Manhattan plot.

### Plotting

The plotting strategy used in the `create_manhattan_plot` function focuses on visualizing GWAS data in a Manhattan
plot by arranging SNPs along the genome and displaying their significance.
The function first calculates cumulative base pair positions (`BPcum`) across chromosomes to position SNPs accurately
along the x-axis. This allows for a continuous representation of SNPs across all chromosomes.

The data is then grouped and summarized to calculate chromosome-specific lengths and their cumulative totals,
which are used to adjust the SNP positions. The plot itself is generated using `ggplot2`,
where SNPs are plotted with their cumulative positions on the x-axis and the negative logarithm of their p-values on the y-axis.
Chromosomes are color-coded alternately for visual clarity, and custom axis labels are created to represent the center of each chromosome.

## Caching

The repository holds different folders with the same shiny application but implementing different levels of caching.
The methods below are gradually more complex but increasingly more powerful.


### 01 - No Cache
Reactive expressions (`reactive()`, `reactiveVal()`, `reactiveValues()`) inherently provide a basic form of caching.
They store their outputs and only re-execute when their reactive dependencies change.
This means that if the inputs remain the same, the stored result is reused without recomputation.

See the app in the [no_cache](01-no_cache) folder. 

## 02 - Basic Cache
Introduced in Shiny 1.6.0, `bindCache()` allows developers to cache the results of reactive expressions or render
functions based on specified keys.
The cached data is stored in memory, leading to faster retrieval times for repeated computations with the same inputs.

See the app in the [basic_cache](02-basic_cache) folder.

### 03 - Local Cache
While `bindCache()` defaults to in-memory caching, it can be configured to use file system caching.
By setting `shinyOptions(cache = cachem::cache_disk("path/to/cache"))`, cached results are stored on the disk.
This approach is beneficial for large datasets or when the application restarts, ensuring cached results persist across sessions.

See the app in the [local_cache](03-local_cache) folder.

### 04 - Redis Caching 
For applications that require shared caching across multiple R sessions or servers, Redis provides a powerful solution.
Redis allows caching data in a centralized location, enabling different Shiny instances (e.g., on different servers)
to access the same cache.
This is particularly useful in load-balanced environments or when scaling Shiny apps.

See the app in the [redis_cache](04-redis_cache) folder.

## Warming up the cache

Only relevant for app wide / global cache 

Need to fix the plot dimensions 

Run shinyloadtest or test server code 


### Shinyloadtest


### Test Server
