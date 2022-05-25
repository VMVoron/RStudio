{r}
url = "https://dspace.spbu.ru/bitstream/11701/6147/1/08-Vasilkova.pdf"
library(pdftools)
text <- pdf_text(url)
library(textclean)
x <- as.factor(text)
y <- check_text(x)
text2 <-replace_html(text)
text3 <- strip(text2, lower.case = FALSE, char.keep = c("?", ".", ','), apostrophe.remove = TRUE)
text4 <-replace_kern(text3)
text4
write.csv2(text4, file = 'text4.csv2')
len <- length(text4)
i = 1
txt3 <- ""
for (i in 1:len)
{
  txt3 <- paste(txt3, text4[i], sep = "", collapse = NULL)
}
txt3
write.table(txt3, file = "test.txt", sep = "\t",
            row.names = TRUE, col.names = NA)