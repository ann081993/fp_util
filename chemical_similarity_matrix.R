#### 2019-10-29 chemial similarity matrix
source("/home/oem/ml/fp_util_src.R")

#### obesogen
name <- c("Avobenzone", "Oxybenzone", "Dioxybenzone", "Bis(2-ethylhexyl) phthalate",
          "Benzyl butyl phthalate")
name <- c("AVB", "BP-3", "BP-8", "DEHP", "BBP")
smiles <- c("CC(C)(C)C1=CC=C(C=C1)C(=O)CC(=O)C2=CC=C(C=C2)OC",
            "COC1=CC(=C(C=C1)C(=O)C2=CC=CC=C2)O",
            "COC1=CC(=C(C=C1)C(=O)C2=CC=CC=C2O)O",
            "CCCCC(CC)COC(=O)C1=CC=CC=C1C(=O)OCC(CC)CCCC",
            "CCCCOC(=O)C1=CC=CC=C1C(=O)OCC2=CC=CC=C2")
fpmatrix_ob_pchem <- smi2fp(smiles)
fpmatrix_ob_ecfp <- smi2fp(smiles, "circular")
fpjacdis_ob_pchem <- fp2jacdis(fpmatrix_ob_pchem)
fpjacdis_ob_ecfp <- fp2jacdis(fpmatrix_ob_ecfp)

rownames(fpjacdis_ob_pchem) <- name
colnames(fpjacdis_ob_pchem) <- name

rownames(fpjacdis_ob_ecfp) <- name
colnames(fpjacdis_ob_ecfp) <- name

heatmap(fpjacdis_ob_pchem)
pdf("Obesogen chemical similarity red 191028 ASC", width = 5, height = 5)
library(gplots)
heatmap.2(fpjacdis_ob_pchem, col = colorpanel(1000, "white", "red"), trace = "none", key = FALSE, margins=c(8, 8),
          sepcolor = "black", colsep = 0:nrow(fpjacdis_ob_pchem), rowsep = 0:nrow(fpjacdis_ob_pchem), sepwidth=c(0.01,0.01),
          cellnote = round(fpjacdis_ob_pchem, 2), notecol = "black", notecex = 1.5, dendrogram = "col",
          cexRow = 1.5, cexCol = 1.5) # *** final
dev.off()

# Ref heatmap.2: https://www.rdocumentation.org/packages/gplots/versions/3.0.1.1/topics/heatmap.2
# Ref for cellnot (heatmap with values): https://stackoverflow.com/questions/21386921/display-values-on-heatmap-in-r
# Ref: http://mannheimiagoesprogramming.blogspot.com/2012/06/drawing-heatmaps-in-r-with-heatmap2.html
# Ref for sperating lines: https://rpubs.com/melike/corrplot; https://stackoverflow.com/questions/21624881/draw-cell-borders-using-heatmap-2
heatmap.2(fpjacdis_ob_ecfp, tracecol="#303030", trace="none", keysize = 1.5, margins=c(18, 18)) # scale for using Z-Score...

install.packages("corrplot")
library(corrplot)
corrplot(fpjacdis_ob_pchem, method = "number", col = colorpanel(100, "azure", "green")) # *** final

#### BPA 2019-12-11
name <- c("BPA", "AVB", "BP-3", "BP-8", "DEHP", "BBP", "BPH")
smiles <- c("CC(C)(C1=CC=C(C=C1)O)C2=CC=C(C=C2)O",
            "CC(C)(C)C1=CC=C(C=C1)C(=O)CC(=O)C2=CC=C(C=C2)OC",
            "COC1=CC(=C(C=C1)C(=O)C2=CC=CC=C2)O",
            "COC1=CC(=C(C=C1)C(=O)C2=CC=CC=C2O)O",
            "CCCCC(CC)COC(=O)C1=CC=CC=C1C(=O)OCC(CC)CCCC",
            "CCCCOC(=O)C1=CC=CC=C1C(=O)OCC2=CC=CC=C2",
            "C1=CC=C(C=C1)C(=NN)C2=CC=CC=C2")

aa <- read.csv("/home/oem/ml/adipoml/FDA800_200207.csv", stringsAsFactors = FALSE)
name <- aa$Name[1:50]
smiles <- aa$Smiles[1:50]

#### 2020-03-23 chemical similarity matrix & chemical space for Molsim
#1) chemical similarity matrix
fpmatrix <- smi2fp(smiles)
fpjacdis <- fp2jacdis(fpmatrix)

rownames(fpjacdis) <- name
colnames(fpjacdis) <- name

library(gplots)
color_0 = "white"
color_1 = "red"

heatmap.2(fpjacdis, col = colorpanel(2000, color_0, color_1), trace = "none", key = FALSE, margins=c(8, 8),
          sepcolor = "black", colsep = 0:nrow(fpjacdis), rowsep = 0:nrow(fpjacdis), sepwidth=c(0.01,0.01),
          cellnote = round(fpjacdis, 2), notecol = "black", notecex = 1 + log10(nrow(fpjacdis)), dendrogram = "col",
          cexRow = 1 + log10(nrow(fpjacdis)), cexCol = 1 + log10(nrow(fpjacdis)))

#2) chemical space
library(tsne)
fptsne <- tsne(fpmatrix)
fptsne <- tsne(fpjacdis)
plot(fptsne)
ggplot(data = as.data.frame(fptsne), aes(x = V1, y = V2, size = 3)) + geom_point(show.legend = F) +
        geom_text_repel(aes(label = name), show.legend = FALSE, box.padding = 0.4) +
        scale_shape_manual(values=c(16, 25)) +
        theme_bw(base_size = 20) + coord_equal()


fppca <- prcomp(fpmatrix)
fppca <- prcomp(fpjacdis)
plot(fppca$x[, 1:2])

library(ggplot2)
library(ggrepel)
ggplot(data = as.data.frame(fppca$x[, 1:2]), aes(x = PC1, y = PC2, size = 3)) + geom_point(show.legend = F) +
        geom_text_repel(aes(label = name), show.legend = FALSE, box.padding = 0.4) +
        scale_shape_manual(values=c(16, 25)) +
        theme_bw(base_size = 20) + coord_equal()

