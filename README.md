# AI-Powered Smart Service Marketplace with Intelligent Discovery and Dynamic Pricing Models

A final-year university research project building an intelligent mobile marketplace that connects Sri Lankan customers with household service workers (plumbers, electricians, carpenters, etc.) using a 4-component AI backend.

---

## System Components

### Component 01 — Intelligent Service Discovery & Intent Recognition
> *Translates messy human complaints into structured job categories.*

Customers often type informal, code-mixed queries in Singlish. This NLP pipeline cleans the text and classifies the intent into a structured Worker Category which is then passed to Component 02.

---

### Component 02 — Hybrid Worker Recommendation Engine
> *Ranks and returns the Top 20 most suitable workers.*

Uses a hybrid pipeline — a Machine Learning model (Random Forest) scores workers based on historical data (NVQ qualifications, past job completion times), and a real-time mathematical model adjusts that score using live GPS distance and live trust ratings from Component 03.

---

### Component 03 — Hybrid Sentiment & Trust Scoring Engine
> *Generates a reliable, category-specific trust score for every worker.*

An NLP classifier (Naive Bayes / SVM) reads Singlish/English text reviews and labels them Positive or Negative. This sentiment ratio is then mathematically fused with the star rating to produce a final Intelligent Trust Score — isolated per job category.

---

### Component 04 — Dynamic Price Prediction Engine
> *Predicts a fair estimated price range for the requested job.*

Based on the identified job category, worker qualifications, geographic location, and historical pricing data, this component predicts the nearest realistic price estimate for the service. This helps customers set expectations and reduces on-site pricing disputes.

---

## Contributors

| Name | Student ID |
|---|---|
| Bandara W.A.M.S | IT22551320 |
| Shiwanthika M.M | IT22283658 |
| Wijebandara W.N.S.K | IT22643704 |
| Kumara A.J.T.M | IT22137982 |

---

## License

This project is developed for academic research purposes.
