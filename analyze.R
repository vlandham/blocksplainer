setwd("~/code/sites/blocksplainer")

require('ggplot2')
require('ddply')
require('ggthemes')

data <- read.delim("api.tsv", sep="\t", header=TRUE)
colnames(data) <- c("origin", "target", "count", "total")
data$frequency <- data$count / data$total

nodes <- unique(data['origin'])

node_connections <- ddply(data, "origin", summarize, links = length(target))
node_connections <- node_connections[with(node_connections, order(-links)), ]

node_totals <- ddply(data, "origin", summarize, total = total[1])
node_totals <- node_totals[with(node_totals, order(-total)), ]


m <- ggplot(node_totals, aes(x=total)) + labs(title = "Histogram of Associated Blocks", x="Number of Blocks")
m <- m + geom_histogram(binwidth=35) + theme_economist()
ggsave("out/histogram_counts.pdf", m)


p <- ggplot(node_totals, aes(x=factor(origin, levels=as.character(node_totals$origin)), y=total)) + labs(title="Related Blocks per API Call", y="Number of Related Blocks", x= "")
p <- p + geom_bar(stat = "identity") + coord_flip() + theme_economist()
ggsave("out/all_sizes.pdf", p, width = 12, height = 42)

m <- ggplot(node_connections, aes(x=links)) + labs(title = "Histogram of Co-ocurrance Entries", x="Number of Co-ocurranant APIs")
m <- m + geom_histogram(binwidth=5) + theme_economist()
ggsave("out/histogram_links.pdf", m)

m <- ggplot(data, aes(x=frequency * 100)) + labs(title = "Histogram of Co-ocurrance Frquencies", x="Co-ocurrance Frenquency")
m + geom_histogram(binwidth=10)

total_coocurs <- ddply(data, "origin", summarize, total = sum(count))
total_coocurs <- total_coocurs[with(total_coocurs, order(-total)), ]

m <- ggplot(total_coocurs, aes(x=total)) + labs(title = "Total Co-ocurrance Counts", x="Total Counts for API")
m + geom_histogram(binwidth=100) + theme_economist()

quantile(data$count)
quantile(data$frequency)
low_counts <- subset(data,count < 50)
high_counts <- subset(data,count >= 50)

m <- ggplot(low_counts, aes(x=count)) + labs(title="Coocurrance Raw Values - Only Low")
m + geom_histogram(binwidth=1) + theme_economist()

p <- ggplot(node_connections, aes(x=factor(origin, levels=as.character(node_connections$origin)), y=links)) + labs(title="Coocurances per API call")
p <- p + geom_bar(stat = "identity") + coord_flip() + theme_economist()
ggsave("out/connection_counts.pdf", p, width = 12, height = 42)

#p <- ggplot(data, aes(x=origin))
