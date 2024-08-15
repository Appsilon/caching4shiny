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

Note: You'll need to have Redis running locally to use this code, the easiest way to do so is by using [Docker](https://www.docker.com/)
and start redis with the command below:

```shell
docker run --rm --name redisbank -d -p 6379:6379 redis
```

## Warming up the cache

Warming up the cache is only relevant for app-wide or global cache strategies.
The primary purpose is to pre-load the cache with commonly requested data or plot outputs so that the initial user
interactions are fast and responsive.

One critical aspect of warming up the cache, especially for Shiny applications with graphical outputs,
is to fix the plot dimensions.
Without this, different user browser sizes can result in varying plot dimensions,
leading to cache misses even if the data is the same.

To warm up the cache, you can simulate user interactions using tools like **shinyloadtest** or a custom **test server** code.
This approach will ensure that your cache is populated with expected user data and plot outputs,
ready to be served without delays when the app is live.

Additionally, remember to clear the cache before running shinyloadtest or any test server simulation.
This ensures that you're starting with a clean slate, accurately capturing how the cache would behave from a cold start.

More details on the specific approaches are provided below:

### Shinyloadtest

**Shinyloadtest** is a package that allows you to record and replay user sessions in a Shiny app to simulate multiple user interactions and warm up the cache.

To get started:

1. Install the `shinyloadtest` package:
   
   ```R
   install.packages("shinyloadtest")
   ```

2. Install `shinycannon`, which is the tool used for replaying recorded sessions.
You can follow the installation instructions [here](https://rstudio.github.io/shinyloadtest/articles/shinycannon.html).

3. Record a user session for your Shiny app:

   ```R
   shinyloadtest::record_session("http://127.0.0.1:4153")
   ```
Note: You'll need to change the url to match either the one on your local or where it has been deployed.

4. Simulate multiple users interacting with the app and trigger the cache using `shinycannon`:

   ```bash
   shinycannon recording.log http://127.0.0.1:4153 --workers 5 --loaded-duration-minutes 2 --output-dir run1
   ```

5. Optional: Process and analyze the results:

   ```R
   df <- shinyloadtest::load_runs("run1")
   shinyloadtest::shinyloadtest_report(df, "run1.html")
   ```

### Test Server

Alternatively, you can use a **test server** to simulate user interactions and cache warm-up through unit tests.
This can be done using the `testthat` package, which is commonly used for unit testing in R.

1. Install the `testthat` package:

   ```R
   install.packages("testthat")
   ```

2. Example code to simulate interactions with the server and trigger the caching mechanism:

   ```R
    source("app.R")
    
    testServer(server, {
    # Simulate interaction with n_points = 500000
    session$setInputs(n_points = 500000)
    expect_equal(nrow(data()), 500000)
    output$manhattanPlot  # Simulates rendering of the plot
    
    # Simulate interaction with n_points = 1000000
    session$setInputs(n_points = 1000000)
    expect_equal(nrow(data()), 1000000)
    output$manhattanPlot  # Simulates rendering of the plot
    
    # Simulate interaction with n_points = 1500000
    session$setInputs(n_points = 1500000)
    expect_equal(nrow(data()), 1500000)
    output$manhattanPlot  # Simulates rendering of the plot
    
    # Simulate interaction with n_points = 2000000
    session$setInputs(n_points = 2000000)
    expect_equal(nrow(data()), 2000000)
    output$manhattanPlot  # Simulates rendering of the plot
    
    # Simulate interaction with n_points = 2500000
    session$setInputs(n_points = 2500000)
    expect_equal(nrow(data()), 2500000)
    output$manhattanPlot  # Simulates rendering of the plot
    
    # Simulate interaction with n_points = 3000000
    session$setInputs(n_points = 3000000)
    expect_equal(nrow(data()), 3000000)
    output$manhattanPlot  # Simulates rendering of the plot
    })

   ```

This script simulates the app behavior for different `n_points` values and ensures that the cache is populated for these cases.
You can modify it to cover the most typical interactions in your app.

### Scheduling the Cache Warm-up

To ensure that the cache is always up-to-date, you can schedule the cache warming as a periodic job (e.g., using a cron job or another scheduling tool).
This scheduled job should:

1. Clear the cache at the start.
2. Run either the **shinyloadtest** or **test server** code to repopulate the cache.
3. Optionally, include logging to monitor the cache warm-up process.

By regularly warming up the cache, you can ensure a consistently fast experience for your users, even during peak usage times.


