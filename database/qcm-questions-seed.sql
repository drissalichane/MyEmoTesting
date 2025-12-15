-- ============================================
-- QCM QUESTIONS - 10 Single Choice Questions per Template
-- ============================================

-- Delete existing questions first
DELETE FROM qcm_question;

-- ============================================
-- QCM 1: Évaluation Émotionnelle Initiale (10 questions)
-- ============================================

INSERT INTO qcm_question (qcm_id, position, question_text, question_type, options, weight) VALUES

(1, 1, 'Comment évaluez-vous votre humeur générale aujourd''hui ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Excellente", "points": 10},
   {" value": "B", "text": "Bonne", "points": 8},
   {"value": "C", "text": "Moyenne", "points": 5},
   {"value": "D", "text": "Mauvaise", "points": 2},
   {"value": "E", "text": "Très mauvaise", "points": 0}
 ]}', 1.0),

(1, 2, 'Avez-vous ressenti de l''anxiété au cours des dernières 24 heures ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Pas du tout", "points": 10},
   {"value": "B", "text": "Un peu", "points": 7},
   {"value": "C", "text": "Modérément", "points": 5},
   {"value": "D", "text": "Beaucoup", "points": 2},
   {"value": "E", "text": "Énormément", "points": 0}
 ]}', 1.0),

(1, 3, 'Avez-vous bien dormi la nuit dernière ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Très bien (7-8h)", "points": 10},
   {"value": "B", "text": "Bien (5-7h)", "points": 7},
   {"value": "C", "text": "Moyennement (3-5h)", "points": 4},
   {"value": "D", "text": "Mal (1-3h)", "points": 2},
   {"value": "E", "text": "Très mal (<1h)", "points": 0}
 ]}', 1.0),

(1, 4, 'Comment évaluez-vous votre niveau d''énergie ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Très énergique", "points": 10},
   {"value": "B", "text": "Énergique", "points": 8},
   {"value": "C", "text": "Normal", "points": 5},
   {"value": "D", "text": "Fatigué", "points": 2},
   {"value": "E", "text": "Épuisé", "points": 0}
 ]}', 1.0),

(1, 5, 'Avez-vous eu des pensées négatives récurrentes ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Jamais", "points": 10},
   {"value": "B", "text": "Rarement", "points": 7},
   {"value": "C", "text": "Parfois", "points": 5},
   {"value": "D", "text": "Souvent", "points": 2},
   {"value": "E", "text": "Constamment", "points": 0}
 ]}', 1.0),

(1, 6, 'Vous sentez-vous capable de gérer vos émotions actuellement ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Totalement", "points": 10},
   {"value": "B", "text": "Généralement", "points": 7},
   {"value": "C", "text": "Parfois", "points": 5},
   {"value": "D", "text": "Rarement", "points": 2},
   {"value": "E", "text": "Pas du tout", "points": 0}
 ]}', 1.0),

(1, 7, 'Avez-vous eu des interactions sociales positives récemment ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Oui, plusieurs", "points": 10},
   {"value": "B", "text": "Oui, quelques-unes", "points": 7},
   {"value": "C", "text": "Une ou deux", "points": 5},
   {"value": "D", "text": "Aucune", "points": 2},
   {"value": "E", "text": "J''ai évité les interactions", "points": 0}
 ]}', 1.0),

(1, 8, 'Comment trouvez-vous votre appétit ces derniers jours ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Excellent, normal", "points": 10},
   {"value": "B", "text": "Bon", "points": 7},
   {"value": "C", "text": "Moyen, légère variation", "points": 5},
   {"value": "D", "text": "Diminué", "points": 2},
   {"value": "E", "text": "Très diminué ou augmenté", "points": 0}
 ]}', 1.0),

(1, 9, 'Avez-vous ressenti du plaisir dans vos activités quotidiennes ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Beaucoup de plaisir", "points": 10},
   {"value": "B", "text": "Du plaisir", "points": 7},
   {"value": "C", "text": "Un peu de plaisir", "points": 5},
   {"value": "D", "text": "Très peu", "points": 2},
   {"value": "E", "text": "Aucun plaisir", "points": 0}
 ]}', 1.0),

(1, 10, 'Vous sentez-vous optimiste concernant votre rétablissement ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Très optimiste", "points": 10},
   {"value": "B", "text": "Optimiste", "points": 7},
   {"value": "C", "text": "Neutre", "points": 5},
   {"value": "D", "text": "Peu optimiste", "points": 2},
   {"value": "E", "text": "Pas du tout optimiste", "points": 0}
 ]}', 1.0);

-- QCM 2: Échelle d'Anxiété GAD-7 (10 questions)

INSERT INTO qcm_question (qcm_id, position, question_text, question_type, options, weight) VALUES

(2, 1, 'Vous êtes-vous senti(e) nerveux(se), anxieux(se) ou très tendu(e) ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Jamais", "points": 10},
   {"value": "B", "text": "Plusieurs jours", "points": 7},
   {"value": "C", "text": "Plus de la moitié du temps", "points": 3},
   {"value": "D", "text": "Presque tous les jours", "points": 0}
 ]}', 1.0),

(2, 2, 'Avez-vous été incapable de vous empêcher de vous inquiéter ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Jamais", "points": 10},
   {"value": "B", "text": "Plusieurs jours", "points": 7},
   {"value": "C", "text": "Plus de la moitié du temps", "points": 3},
   {"value": "D", "text": "Presque tous les jours", "points": 0}
 ]}', 1.0),

(2, 3, 'Vous inquiétez-vous trop à propos de tout et de rien ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Jamais", "points": 10},
   {"value": "B", "text": "Plusieurs jours", "points": 7},
   {"value": "C", "text": "Plus de la moitié du temps", "points": 3},
   {"value": "D", "text": "Presque tous les jours", "points": 0}
 ]}', 1.0),

(2, 4, 'Avez-vous eu du mal à vous détendre ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Jamais", "points": 10},
   {"value": "B", "text": "Plusieurs jours", "points": 7},
   {"value": "C", "text": "Plus de la moitié du temps", "points": 3},
   {"value": "D", "text": "Presque tous les jours", "points": 0}
 ]}', 1.0),

(2, 5, 'Êtes-vous resté(e) assis(e) sans pouvoir tenir en place ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Jamais", "points": 10},
   {"value": "B", "text": "Plusieurs jours", "points": 7},
   {"value": "C", "text": "Plus de la moitié du temps", "points": 3},
   {"value": "D", "text": "Presque tous les jours", "points": 0}
 ]}', 1.0),

(2, 6, 'Vous êtes-vous senti(e) facilement contrarié(e) ou irritable ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Jamais", "points": 10},
   {"value": "B", "text": "Plusieurs jours", "points": 7},
   {"value": "C", "text": "Plus de la moitié du temps", "points": 3},
   {"value": "D", "text": "Presque tous les jours", "points": 0}
 ]}', 1.0),

(2, 7, 'Avez-vous eu peur que quelque chose de terrible se produise ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Jamais", "points": 10},
   {"value": "B", "text": "Plusieurs jours", "points": 7},
   {"value": "C", "text": "Plus de la moitié du temps", "points": 3},
   {"value": "D", "text": "Presque tous les jours", "points": 0}
 ]}', 1.0),

(2, 8, 'Avez-vous ressenti des palpitations cardiaques ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Jamais", "points": 10},
   {"value": "B", "text": "Plusieurs jours", "points": 7},
   {"value": "C", "text": "Plus de la moitié du temps", "points": 3},
   {"value": "D", "text": "Presque tous les jours", "points": 0}
 ]}', 1.0),

(2, 9, 'Avez-vous eu des difficultés de concentration ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Jamais", "points": 10},
   {"value": "B", "text": "Plusieurs jours", "points": 7},
   {"value": "C", "text": "Plus de la moitié du temps", "points": 3},
   {"value": "D", "text": "Presque tous les jours", "points": 0}
 ]}', 1.0),

(2, 10, 'Avez-vous ressenti des tensions musculaires ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Jamais", "points": 10},
   {"value": "B", "text": "Plusieurs jours", "points": 7},
   {"value": "C", "text": "Plus de la moitié du temps", "points": 3},
   {"value": "D", "text": "Presque tous les jours", "points": 0}
 ]}', 1.0);

-- QCM 3: Inventaire de Dépression de Beck (10 questions)

INSERT INTO qcm_question (qcm_id, position, question_text, question_type, options, weight) VALUES

(3, 1, 'Comment vous sentez-vous par rapport à votre humeur ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Je ne me sens pas triste", "points": 10},
   {"value": "B", "text": "Je me sens triste", "points": 7},
   {"value": "C", "text": "Je suis triste tout le temps", "points": 3},
   {"value": "D", "text": "Je suis si triste que je ne peux pas le supporter", "points": 0}
 ]}', 1.0),

(3, 2, 'Comment percevez-vous votre avenir ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Je suis optimiste quant à mon avenir", "points": 10},
   {"value": "B", "text": "Je suis un peu découragé", "points": 7},
   {"value": "C", "text": "Je ne crois rien de bon m''attend", "points": 3},
   {"value": "D", "text": "Mon avenir est sans espoir", "points": 0}
 ]}', 1.0),

(3, 3, 'Vous sentez-vous en échec ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Je n''ai pas le sentiment d''être un échec", "points": 10},
   {"value": "B", "text": "J''ai échoué plus que je n''aurais dû", "points": 7},
   {"value": "C", "text": "J''ai échoué dans tout ce que j''ai fait", "points": 3},
   {"value": "D", "text": "Je suis un échec total en tant que personne", "points": 0}
 ]}', 1.0),

(3, 4, 'Éprouvez-vous du plaisir dans la vie ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "J''éprouve autant de plaisir qu''avant", "points": 10},
   {"value": "B", "text": "J''éprouve moins de plaisir qu''avant", "points": 7},
   {"value": "C", "text": "Je n''éprouve que très peu de plaisir", "points": 3},
   {"value": "D", "text": "Je n''éprouve aucun plaisir", "points": 0}
 ]}', 1.0),

(3, 5, 'Vous sentez-vous coupable ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Je ne me sens pas particulièrement coupable", "points": 10},
   {"value": "B", "text": "Je me sens coupable une bonne partie du temps", "points": 7},
   {"value": "C", "text": "Je me sens coupable la plupart du temps", "points": 3},
   {"value": "D", "text": "Je me sens toujours coupable", "points": 0}
 ]}', 1.0),

(3, 6, 'Comment percevez-vous votre santé ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Ma santé ne m''inquiète pas plus que d''habitude", "points": 10},
   {"value": "B", "text": "Je suis préoccupé par ma santé", "points": 7},
   {"value": "C", "text": "Je suis très préoccupé par ma santé", "points": 3},
   {"value": "D", "text": "Ma santé m''obsède complètement", "points": 0}
 ]}', 1.0),

(3, 7, 'Avez-vous perdu l''intérêt pour les autres ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Je n''ai pas perdu l''intérêt pour les autres", "points": 10},
   {"value": "B", "text": "Je m''intéresse moins aux autres qu''avant", "points": 7},
   {"value": "C", "text": "J''ai presque perdu tout intérêt pour les autres", "points": 3},
   {"value": "D", "text": "J''ai complètement perdu l''intérêt pour les autres", "points": 0}
 ]}', 1.0),

(3, 8, 'Avez-vous des difficultés à prendre des décisions ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Je prends des décisions aussi bien qu''avant", "points": 10},
   {"value": "B", "text": "Il m''est un peu plus difficile de prendre des décisions", "points": 7},
   {"value": "C", "text": "Il m''est très difficile de prendre des décisions", "points": 3},
   {"value": "D", "text": "Je suis incapable de prendre des décisions", "points": 0}
 ]}', 1.0),

(3, 9, 'Comment vous sentez-vous physiquement ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Je ne suis pas plus fatigué(e) que d''habitude", "points": 10},
   {"value": "B", "text": "Je me fatigue plus facilement", "points": 7},
   {"value": "C", "text": "Je suis trop fatigué(e) pour faire quoi que ce soit", "points": 3},
   {"value": "D", "text": "Je suis trop fatigué(e) même pour me lever", "points": 0}
 ]}', 1.0),

(3, 10, 'Comment vous percevez-vous ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Je ne pense pas avoir l''air différent", "points": 10},
   {"value": "B", "text": "Je m''inquiète de paraître vieux ou peu attrayant", "points": 7},
   {"value": "C", "text": "Je sens des changements permanents dans mon apparence", "points": 3},
   {"value": "D", "text": "Je crois que j''ai l''air laid", "points": 0}
 ]}', 1.0);

-- QCM 4: Qualité de Vie et Bien-être (10 questions)

INSERT INTO qcm_question (qcm_id, position, question_text, question_type, options, weight) VALUES

(4, 1, 'Comment évaluez-vous votre qualité de vie globale ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Excellente", "points": 10},
   {"value": "B", "text": "Très bonne", "points": 8},
   {"value": "C", "text": "Bonne", "points": 6},
   {"value": "D", "text": "Acceptable", "points": 3},
   {"value": "E", "text": "Mauvaise", "points": 0}
 ]}', 1.0),

(4, 2, 'Êtes-vous satisfait(e) de votre santé ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Très satisfait", "points": 10},
   {"value": "B", "text": "Satisfait", "points": 7},
   {"value": "C", "text": "Moyennement satisfait", "points": 5},
   {"value": "D", "text": "Insatisfait", "points": 2},
   {"value": "E", "text": "Très insatisfait", "points": 0}
 ]}', 1.0),

(4, 3, 'Comment trouvez-vous vos relations personnelles ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Très satisfaisantes", "points": 10},
   {"value": "B", "text": "Satisfaisantes", "points": 7},
   {"value": "C", "text": "Moyennes", "points": 5},
   {"value": "D", "text": "Insatisfaisantes", "points": 2},
   {"value": "E", "text": "Très insatisfaisantes", "points": 0}
 ]}', 1.0),

(4, 4, 'Vous sentez-vous capable de faire face aux problèmes quotidiens ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Tout à fait capable", "points": 10},
   {"value": "B", "text": "Généralement capable", "points": 7},
   {"value": "C", "text": "Parfois capable", "points": 5},
   {"value": "D", "text": "Rarement capable", "points": 2},
   {"value": "E", "text": "Incapable", "points": 0}
 ]}', 1.0),

(4, 5, 'Avez-vous le sentiment que votre vie a un sens ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Tout à fait", "points": 10},
   {"value": "B", "text": "Dans une grande mesure", "points": 7},
   {"value": "C", "text": "Modérément", "points": 5},
   {"value": "D", "text": "Un peu", "points": 2},
   {"value": "E", "text": "Pas du tout", "points": 0}
 ]}', 1.0),

(4, 6, 'Comment évaluez-vous votre capacité à vous concentrer ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Excellente", "points": 10},
   {"value": "B", "text": "Bonne", "points": 7},
   {"value": "C", "text": "Moyenne", "points": 5},
   {"value": "D", "text": "Faible", "points": 2},
   {"value": "E", "text": "Très faible", "points": 0}
 ]}', 1.0),

(4, 7, 'Vous sentez-vous en sécurité dans votre vie quotidienne ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Tout à fait en sécurité", "points": 10},
   {"value": "B", "text": "Généralement en sécurité", "points": 7},
   {"value": "C", "text": "Moyennement en sécurité", "points": 5},
   {"value": "D", "text": "Peu en sécurité", "points": 2},
   {"value": "E", "text": "Pas du tout en sécurité", "points": 0}
 ]}', 1.0),

(4, 8, 'Votre environnement physique est-il sain ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Très sain", "points": 10},
   {"value": "B", "text": "Sain", "points": 7},
   {"value": "C", "text": "Moyennement sain", "points": 5},
   {"value": "D", "text": "Peu sain", "points": 2},
   {"value": "E", "text": "Pas du tout sain", "points": 0}
 ]}', 1.0),

(4, 9, 'Avez-vous suffisamment d''énergie pour vos activités quotidiennes ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Complètement", "points": 10},
   {"value": "B", "text": "La plupart du temps", "points": 7},
   {"value": "C", "text": "Modérément", "points": 5},
   {"value": "D", "text": "Un peu", "points": 2},
   {"value": "E", "text": "Pas du tout", "points": 0}
 ]}', 1.0),

(4, 10, 'Êtes-vous satisfait de votre sommeil ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Très satisfait", "points": 10},
   {"value": "B", "text": "Satisfait", "points": 7},
   {"value": "C", "text": "Moyennement satisfait", "points": 5},
   {"value": "D", "text": "Insatisfait", "points": 2},
   {"value": "E", "text": "Très insatisfait", "points": 0}
 ]}', 1.0);

-- QCM 5: Gestion du Stress (10 questions)

INSERT INTO qcm_question (qcm_id, position, question_text, question_type, options, weight) VALUES

(5, 1, 'À quelle fréquence vous sentez-vous stressé(e) ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Jamais", "points": 10},
   {"value": "B", "text": "Rarement", "points": 7},
   {"value": "C", "text": "Parfois", "points": 5},
   {"value": "D", "text": "Souvent", "points": 2},
   {"value": "E", "text": "Toujours", "points": 0}
 ]}', 1.0),

(5, 2, 'Arrivez-vous à vous détendre facilement ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Très facilement", "points": 10},
   {"value": "B", "text": "Facilement", "points": 7},
   {"value": "C", "text": "Avec difficulté", "points": 5},
   {"value": "D", "text": "Avec grande difficulté", "points": 2},
   {"value": "E", "text": "Impossible", "points": 0}
 ]}', 1.0),

(5, 3, 'Utilisez-vous des techniques de relaxation ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Régulièrement et efficacement", "points": 10},
   {"value": "B", "text": "Parfois avec succès", "points": 7},
   {"value": "C", "text": "Rarement", "points": 5},
   {"value": "D", "text": "J''essaie mais sans succès", "points": 2},
   {"value": "E", "text": "Jamais", "points": 0}
 ]}', 1.0),

(5, 4, 'Comment gérez-vous les situations difficiles ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Très bien, je reste calme", "points": 10},
   {"value": "B", "text": "Bien, avec quelques efforts", "points": 7},
   {"value": "C", "text": "Difficilement", "points": 5},
   {"value": "D", "text": "Mal, je panique", "points": 2},
   {"value": "E", "text": "Je ne peux pas les gérer", "points": 0}
 ]}', 1.0),

(5, 5, 'Avez-vous un bon équilibre vie professionnelle/personnelle ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Excellent équilibre", "points": 10},
   {"value": "B", "text": "Bon équilibre", "points": 7},
   {"value": "C", "text": "Équilibre moyen", "points": 5},
   {"value": "D", "text": "Mauvais équilibre", "points": 2},
   {"value": "E", "text": "Aucun équilibre", "points": 0}
 ]}', 1.0),

(5, 6, 'Pratiquez-vous une activité physique régulière ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Oui, plusieurs fois par semaine", "points": 10},
   {"value": "B", "text": "Oui, au moins une fois par semaine", "points": 7},
   {"value": "C", "text": "Rarement", "points": 5},
   {"value": "D", "text": "Très rarement", "points": 2},
   {"value": "E", "text": "Jamais", "points": 0}
 ]}', 1.0),

(5, 7, 'Avez-vous un réseau de soutien social ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Oui, un réseau solide", "points": 10},
   {"value": "B", "text": "Oui, quelques personnes", "points": 7},
   {"value": "C", "text": "Réseau limité", "points": 5},
   {"value": "D", "text": "Très peu de soutien", "points": 2},
   {"value": "E", "text": "Aucun soutien", "points": 0}
 ]}', 1.0),

(5, 8, 'Comment dormez-vous en période de stress ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Très bien", "points": 10},
   {"value": "B", "text": "Bien", "points": 7},
   {"value": "C", "text": "Difficulté à s''endormir", "points": 5},
   {"value": "D", "text": "Sommeil perturbé", "points": 2},
   {"value": "E", "text": "Insomnie", "points": 0}
 ]}', 1.0),

(5, 9, 'Prenez-vous du temps pour vous chaque jour ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Oui, régulièrement", "points": 10},
   {"value": "B", "text": "Oui, souvent", "points": 7},
   {"value": "C", "text": "Parfois", "points": 5},
   {"value": "D", "text": "Rarement", "points": 2},
   {"value": "E", "text": "Jamais", "points": 0}
 ]}', 1.0),

(5, 10, 'Vous sentez-vous capable de demander de l''aide quand vous en avez besoin ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Tout à fait capable", "points": 10},
   {"value": "B", "text": "Généralement capable", "points": 7},
   {"value": "C", "text": "Parfois capable", "points": 5},
   {"value": "D", "text": "Rarement capable", "points": 2},
   {"value": "E", "text": "Incapable", "points": 0}
 ]}', 1.0);

-- Verify questions were added
SELECT qcm_id, COUNT(*) as question_count 
FROM qcm_question 
GROUP BY qcm_id 
ORDER BY qcm_id;
