# 🏥 e-Clinique

Bienvenue sur **e-Clinique**, la plateforme intelligente de gestion de rendez-vous et de dossiers médicaux pour cliniques, médecins et patients.  
Ce projet propose une expérience moderne, fluide et sécurisée pour la prise de rendez-vous, le suivi patient et l’organisation des professionnels de santé.

---

## 🚀 Fonctionnalités principales

- **Gestion des rendez-vous**  
  Prise de rendez-vous en ligne, gestion du planning médecin, disponibilité en temps réel, annulation/modification facile.
- **Espace patient**  
  Création de compte, consultation de l’historique des rendez-vous, gestion du profil, recherche de praticiens, suivi médical.
- **Espace médecin**  
  Accès à l’agenda, gestion des patients, accès aux dossiers et notes de consultation, statistiques d’activité, gestion des disponibilités.
- **Espace administrateur**  
  Gestion des utilisateurs (patients, médecins, staff), paramétrage des départements et spécialités, reporting.
- **Notifications intelligentes**  
  Rappels email/SMS, alertes de nouveaux rendez-vous ou annulations.
- **Recherche intelligente**  
  Recherche de médecins par spécialité, département, disponibilité ou nom.

---

## 🖥️ Technologies

- **Backend**: Java EE, Servlets, JSP, JPA (Hibernate)
- **Frontend**: HTML5, CSS3, Bootstrap 5, JavaScript ES6
- **Base de données**: PostgreSQL / MySQL
- **Sécurité**: Authentification par session, gestion des rôles, validation avancée
- **Déploiement**: Apache Tomcat, compatible Docker

---

## 📂 Structure du projet

```
/src
  /main
    /java/com/clinique
      /controller
      /servlet
      /service
      /dto
      /entity
      /repository
    /resources
    /webapp
      /WEB-INF/views
      /assets
      index.jsp
/tests
README.md
```

---

## ⚡ Prise en main rapide

1. **Cloner le projet**
   ```bash
   git clone https://github.com/votre-utilisateur/e-clinique.git
   cd e-clinique
   ```
2. **Configurer la base de données**
    - Créez une base `eclinique` (PostgreSQL ou MySQL).
    - Renseignez les paramètres dans `DBConnection.java`.
3. **Compiler et lancer**
    - Importez dans votre IDE Java (IntelliJ, Eclipse…)
    - Déployez sur Tomcat (>= v9)
    - Accédez à [http://localhost:8080/e-clinique](http://localhost:8080/e-clinique)

---

## 📸 Aperçu

![e-Clinique screenshot 1](assets/img/preview1.png)
![e-Clinique screenshot 2](assets/img/preview2.png)

---

## 💡 Contribution

Les contributions sont les bienvenues !  
Merci de lire le [CONTRIBUTING.md](CONTRIBUTING.md) avant de proposer une issue ou une pull request.

---

## 🛡️ Licence

Ce projet est sous licence MIT.  
© 2025 – [Votre nom ou organisation]

---

<div align="center">
  <b>e-Clinique</b> – Simplifiez la gestion médicale, pour tous.<br>
  <a href="https://github.com/votre-utilisateur/e-clinique">Voir sur GitHub</a>
</div>