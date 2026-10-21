# SOST70022 — ELSA Waves 7–11: reproducibility and validation
# R packages: haven, dplyr, lme4, ggplot2, readr
# The supplied ELSA data are restricted: NEVER commit raw data.
# Script prepared for R execution; later model results were independently re-checked.
# This R script has not yet been run end-to-end to verify those results.
# Run from the repository root after placing data files in data/.

library(haven)
library(dplyr)
library(lme4)
library(ggplot2)
library(readr)

dir.create("outputs", showWarnings = FALSE)
files <- c(
  "7"="wave_7_elsa_data.dta",
  "8"="wave_8_elsa_data_eul_v2.dta",
  "9"="wave_9_elsa_data_eul_v2.dta",
  "10"="wave_10_elsa_data_eul_v4.dta",
  "11"="wave_11_elsa_data_eul.dta"
)
stopifnot(all(file.exists(file.path("data", files))))
raw <- lapply(files, function(f) read_dta(file.path("data", f)))

# Harmonise wave-specific names before stacking observations.
extract_wave <- function(x, wave) {
  if (wave == 7L) {
    x %>% transmute(
      idauniq, wave=wave, scfeela,scfeelb,scfeelc,
      org_po=scorg01,org_nw=scorg02,org_rl=scorg03,
      org_ch=scorg04,org_ed=scorg05,org_sc=scorg06,
      org_sp=scorg07,org_ot=scorg08,
      indager,indsex,couple,hehelf=Hehelf,
      psceda=PScedA,pscedb=PScedB,pscedc=PScedC,pscedd=PScedD
    )
  } else {
    x %>% transmute(
      idauniq, wave=wave, scfeela,scfeelb,scfeelc,
      org_po=scorgpo,org_nw=scorgnw,org_rl=scorgrl,
      org_ch=scorgch,org_ed=scorged,org_sc=scorgsc,
      org_sp=scorgsp,org_ot=scorg95,
      indager,indsex,couple,hehelf,
      psceda,pscedb,pscedc,pscedd
    )
  }
}
long <- bind_rows(Map(function(x,w) extract_wave(x,as.integer(w)),raw,names(raw)))

org <- c("org_po","org_nw","org_rl","org_ch","org_ed","org_sc","org_sp","org_ot")
measures <- c("scfeela","scfeelb","scfeelc",org,
              "indager","indsex","couple","hehelf",
              "psceda","pscedb","pscedc","pscedd")

# First reproduce submitted negative-value handling; a separate age-90+
# sensitivity analysis is needed, because indager=-7 has a disclosure meaning.
long <- long %>% mutate(across(all_of(measures), ~ ifelse(.x<0,NA_real_,as.numeric(.x))))
long <- long %>% mutate(
  loneliness = scfeela + scfeelb + scfeelc,
  social_participation = rowSums(across(all_of(org))),
  wave0 = wave - 7
)

s0 <- long
s1 <- s0 %>% filter(!is.na(loneliness))
s2 <- s1 %>% filter(!is.na(social_participation))
s3 <- s2 %>% filter(if_all(c(indager,indsex,couple,hehelf), ~!is.na(.x)))

sample_flow <- data.frame(
  stage=c("Raw","Outcome available","Participation available","Controls available"),
  observations=c(nrow(s0),nrow(s1),nrow(s2),nrow(s3)),
  people=c(n_distinct(s0$idauniq),n_distinct(s1$idauniq),
           n_distinct(s2$idauniq),n_distinct(s3$idauniq))
)
write_csv(sample_flow,"outputs/sample_flow.csv")
print(sample_flow)
stopifnot(!anyDuplicated(s3[,c("idauniq","wave")]))

by_wave <- s3 %>% group_by(wave) %>% summarise(
  n=n(), people=n_distinct(idauniq),
  mean_loneliness=mean(loneliness),
  sd_loneliness=sd(loneliness),
  mean_participation=mean(social_participation),
  .groups="drop"
)
stopifnot(sum(by_wave$n)==nrow(s3))
write_csv(by_wave,"outputs/summary_by_wave.csv")
write_csv(s3 %>% count(idauniq,name="waves") %>%
            count(waves,name="people"),
          "outputs/panel_balance.csv")
g <- ggplot(by_wave,aes(wave,mean_loneliness))+
  geom_line()+geom_point(size=2)+
  scale_x_continuous(breaks=7:11)+
  labs(title="ELSA loneliness by survey wave",
       x="Wave",y="Mean UCLA three-item loneliness score")+
  theme_minimal()
ggsave("outputs/loneliness_by_wave.png",g,width=8,height=4.5,dpi=180)

# Maximum likelihood, to allow comparisons across nested fixed effects.
m0 <- lmer(loneliness~1+(1|idauniq),data=s3,REML=FALSE)
m1 <- lmer(loneliness~wave0+(1+wave0|idauniq),data=s3,REML=FALSE)
m2_original <- lmer(loneliness~wave0+social_participation+
                      indager+indsex+couple+hehelf+
                      (1+wave0|idauniq),data=s3,REML=FALSE)
m3_original <- lmer(loneliness~wave0*social_participation+
                      indager+indsex+couple+hehelf+
                      (1+wave0|idauniq),data=s3,REML=FALSE)

# Correct marital status to a nominal factor (unlike submitted numeric coding).
s3 <- s3 %>% mutate(
  sex_factor=factor(indsex,levels=c(1,2),labels=c("Male","Female")),
  marital_factor=factor(couple,levels=c(1,2,3),
                        labels=c("Married","Cohabiting","Neither"))
)
m2_corrected <- lmer(loneliness~wave0+social_participation+
                       indager+sex_factor+marital_factor+hehelf+
                       (1+wave0|idauniq),data=s3,REML=FALSE)
m3_corrected <- lmer(loneliness~wave0*social_participation+
                       indager+sex_factor+marital_factor+hehelf+
                       (1+wave0|idauniq),data=s3,REML=FALSE)

models <- list(m0=m0,m1=m1,
               m2_original=m2_original,m3_original=m3_original,
               m2_corrected=m2_corrected,m3_corrected=m3_corrected)
fit <- bind_rows(lapply(names(models),function(nm) {
  x <- models[[nm]]
  data.frame(model=nm,n=nobs(x),AIC=AIC(x),BIC=BIC(x),
             logLik=as.numeric(logLik(x)))
}))
coefs <- bind_rows(lapply(names(models),function(nm) {
  b <- summary(models[[nm]])$coefficients
  data.frame(model=nm,term=rownames(b),estimate=b[,"Estimate"],
             std_error=b[,"Std. Error"],row.names=NULL)
}))
write_csv(fit,"outputs/model_fit.csv")
write_csv(coefs,"outputs/model_coefficients.csv")
capture.output(anova(m2_original,m3_original),
               file="outputs/interaction_comparison_original.txt")
capture.output(anova(m2_corrected,m3_corrected),
               file="outputs/interaction_comparison_corrected.txt")
print(fit)
print(coefs)
print(anova(m2_original,m3_original))
print(anova(m2_corrected,m3_corrected))

# Remaining: validate age 90+ codes, CES-D scoring and unequal calendar intervals.
# Do not claim these checks were completed in the submitted assignment.
