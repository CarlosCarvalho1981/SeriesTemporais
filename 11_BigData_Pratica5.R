#Big data na prática 5 - Análise de séries temporais no mercado financeiro
#Script desenvolvido no curso Forma��o Cientista de Dados da DataScience Academy
#https://www.datascienceacademy.com.br/bundles?bundle_id=formacao-cientista-de-dados
#Exerc�cio para observa��o dos valores de uma a��o na bolsa de valores.
#No caso, a a��o observada � da petrobr�s (PETR4)

#Configurando o diretório de trabalho
setwd("D:/CIENTISTA_DADOS/1_BIG_DATA_R_AZURE/CAP07")
getwd()

#http://www.quantmod.com/

install.packages("quantmod")
install.packages("xts")
install.packages("moments")
library(quantmod)
library(xts)
library(moments)

#Seleção do período de análise
startDate <- as.Date("2018-01-21")
endDate <- as.Date("2018-06-21")

#Download dos dados no período
#weg <- "WEGE3.SA"
getSymbols("PETR4.SA", src = "yahoo", from = startDate, to = endDate, auto.assign = T)
PETR4.SA
class(PETR4.SA)
is.xts(PETR4.SA)

head(PETR4.SA)
colnames(PETR4.SA) <- c("Open", "High", "Low", "Close", "Volume", "Adjusted")
View(PETR4.SA)
PETR4.SA <- PETR4.SA[complete.cases(PETR4.SA), ]

#Analisando os dados de fechamento
PETR4Close <- PETR4.SA[,"Close"]
is.xts(PETR4Close)
head(Cl(PETR4.SA),5)

#Agora vamos plotar o gráfico de candlestick da Petrobrás
candleChart(PETR4.SA)
?candleChart

#Plot de fechamento
plot(PETR4Close, main = "Fechamento Diário PETR4", 
     col = "red", xlab = "Data", ylab = "Preço", major.ticks = "months",
     minor.ticks = FALSE)

#Adicionando as bandas de bollinger ao gráfico, com média de 2 períodos e 2 desvios
addBBands(n = 20, sd = 2)

#Adicionando o indicador ADX, média 11 do tipo exponencial
addADX(n = 11, maType = "EMA")

#Calculando logs diários
PETR4.SA.ret <- diff(log(PETR4Close), lag = 1)
View(PETR4.SA.ret)

PETR4.SA.ret <- PETR4.SA.ret[-1]

#Plotando a taxa de retorno
plot(PETR4.SA.ret, main = "Fechamento Diário PETR4",
     col = "red", xlab = "Data", ylab = "Retorno", major.ticks = "months",
     minor.ticks = FALSE)

#Calculando algumas medidas estatísticas
statNames <- c("Media", "Desvio Padrao", "Inclinacao", "Curtose")
PETR4.SA.stats <- c(mean(PETR4.SA.ret), sd(PETR4.SA.ret), skewness(PETR4.SA.ret), kurtosis(PETR4.SA.ret))
names(PETR4.SA.stats) <- statNames
PETR4.SA.stats

#Salvando os dados em um arquivo .rds (arquivo binário do R)
saveRDS(PETR4.SA, "PETR4.SA.rds") #Salva os dados em formato binário


#Lendo novamente os dados
Ptr <- readRDS("PETR4.SA.rds")
head(Ptr)
































