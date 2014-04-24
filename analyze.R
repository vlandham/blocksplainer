setwd("~/code/sites/blocksplainer")

require('ggplot2')
require('ddply')
require('ggthemes')

data <- read.delim("api.tsv", sep="\t", header=TRUE)
docs <- read.delim("data/docs.tsv", sep="\t", header=TRUE)
docs <- docs[,c('command', 'main')]
colnames(data) <- c("origin", "target", "count", "total")
data$frequency <- data$count / data$total

data <- merge(data, docs, by.x = "origin", by.y="command", sort = FALSE, all.x = TRUE, all.y = FALSE)
no_main <- (subset(data, is.na(main)))

nodes <- unique(data['origin'])


vtheme <- theme_economist(horizontal=FALSE, base_size=10)
#vtheme$plot.background$fill <- "#cccccc"
#vtheme$axis.title$hjust <- 5
vtheme$axis.text.y$hjust <- 1
#vtheme$plot.title$hjust <- 0.06
vtheme$axis.text.x$size <- 16
vtheme$axis.title.x$size <- 16

htheme <- theme_economist(base_size=10)
#vtheme$plot.background$fill <- "#cccccc"
#vtheme$axis.title$hjust <- 5
htheme$axis.text.y$hjust <- 1
#vtheme$plot.title$hjust <- 0.06
htheme$axis.text.x$size <- 16
htheme$axis.title.x$size <- 16


node_connections <- ddply(data, "origin", summarize, links = length(target), type=main[1])
node_connections <- node_connections[with(node_connections, order(links)), ]
#write.table(data.frame(node_connections[is.na(node_connections$type),"origin"], 'Geo', 'Plugin'), "missing.csv", row.names=FALSE, quote=FALSE, sep="\t")

node_totals <- ddply(data, "origin", summarize, total = total[1], type=main[1])
node_totals <- node_totals[with(node_totals, order(total)), ]


m <- ggplot(node_totals, aes(x=total)) + labs(title = "Histogram of Associated Blocks", x="Number of Blocks")
m <- m + geom_histogram(binwidth=35) + theme_economist()
ggsave("out/histogram_counts.pdf", m)


p <- ggplot(node_totals, aes(x=factor(origin, levels=as.character(node_totals$origin)), y=total)) + labs(title="Total Blocks Using Each API", y="# of Blocks", x= "")
p <- p + geom_bar(stat = "identity") + coord_flip() + vtheme
ggsave("out/all_sizes.pdf", p, width = 12, height = 42)

p <- ggplot(node_totals, aes(x=factor(origin, levels=as.character(node_totals$origin)), y=total, fill=type)) + labs(title="Total Blocks Using Each API", y="# of Blocks", x= "")
p <- p + geom_bar(stat = "identity") + coord_flip() + vtheme
ggsave("out/all_sizes_by_type.pdf", p, width = 12, height = 42)

m <- ggplot(node_connections, aes(x=links)) + labs(title = "Co-ocurrant Entries for Each API Call", x="Co-ocurranant API Calls")
m <- m + geom_histogram(binwidth=5) + htheme
ggsave("out/histogram_links.png", m)

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
p <- p + geom_bar(stat = "identity") + coord_flip() + theme_economist(horizontal=FALSE) + scale_colour_economist()
ggsave("out/connection_counts.png", p, width = 12, height = 42)

p <- ggplot(node_connections, aes(x=factor(origin, levels=as.character(node_connections$origin)), y=links, fill=type)) + labs(title="Coocurances per API call", x = "", key="")
p <- p + geom_bar(stat = "identity") + coord_flip() + vtheme + scale_colour_economist()
ggsave("out/connection_counts_by_type.pdf", p, width = 12, height = 48)

p <- ggplot(node_connections[(nrow(node_connections) - 30):(nrow(node_connections)),], aes(x=factor(origin, levels=as.character(node_connections$origin)), y=links, fill=type)) + labs(title="Coocurances per API call", x = "", key="")
p <- p + geom_bar(stat = "identity") + coord_flip() + vtheme + scale_colour_economist()
ggsave("out/connection_counts_by_type_short.png")

#p <- ggplot(data, aes(x=origin))


authors <- read.delim("data/authors.tsv", sep="\t", header=TRUE)
blocks <- read.delim("data/blocks.tsv", sep="\t", header=TRUE)

author_counts <- ddply(blocks, 'author', summarize, count = length(block_id))
author_counts <- author_counts[with(author_counts, order(count)), ]
sum(author_counts$count)

total_authors <- ddply(authors, 'author', summarize, total_count = sum(count))
total_authors <- total_authors[with(total_authors, order(total_count)), ]


vtheme <- theme_economist(horizontal=FALSE, base_size=10)
#vtheme$plot.background$fill <- "#cccccc"
#vtheme$axis.title$hjust <- 5
vtheme$axis.text.y$hjust <- 1
#vtheme$plot.title$hjust <- 0.06
vtheme$axis.text.x$size <- 16
vtheme$axis.title.x$size <- 16


sum(total_authors$total_count)
total_authors[total_authors$author == "mbostock", 'total_count'] # => 4791
total_authors[total_authors$author == "enjalot", 'total_count'] # => 6528

(4791 + 6528) / sum(total_authors$total_count)

p <- ggplot(total_authors, aes(x=factor(author, levels=as.character(total_authors$author)), y=total_count, )) + labs(title="Authors by API Count", x="", y="# of API Calls")
p <- p + geom_bar(stat = "identity") + coord_flip() + vtheme + scale_colour_economist() #+ scale_x_continuous(limits=c(0, 5000))
p
ggsave("out/authors_api_counts.png", p) #, width = 12, height = 42)

p <- ggplot(author_counts, aes(x=factor(author, levels=as.character(author_counts$author)), y=count, )) + labs(title="Authors by Block Count", x="", y="# of Blocks")
p <- p + geom_bar(stat = "identity") + coord_flip() + vtheme + scale_colour_economist() #+ scale_x_continuous(limits=c(0, 5000))
p
ggsave("out/authors_block_counts.png", p) #, width = 12, height = 42)

sum(author_counts$count) #=> 2783
author_counts[author_counts$author == "mbostock", 'count'] # => 656
author_counts[author_counts$author == "enjalot", 'count'] # => 1301
(1301 + 656) / 2783


author_counts[author_counts$author == "vlandham", 'count'] # => 20
