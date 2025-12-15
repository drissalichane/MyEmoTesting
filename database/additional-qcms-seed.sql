-- ============================================
-- Additional QCM Templates (6-10) with Questions
-- ============================================

-- First, add 5 more QCM templates
INSERT INTO qcm_template (title, description, creator_id, category, difficulty_level, estimated_duration_minutes, is_active) VALUES
('Échelle d''Estime de Soi', 'Évaluation du niveau d''estime de soi et de confiance personnelle', 2, 'SELF_ESTEEM', 2, 12, TRUE),
('Test de Résilience Psychologique', 'Mesure de la capacité à surmonter les difficultés', 3, 'RESILIENCE', 3, 18, TRUE),
('Évaluation du Soutien Social', 'Questionnaire sur le réseau de soutien et les relations sociales', 2, 'SOCIAL_SUPPORT', 2, 14, TRUE),
('Qualité du Sommeil', 'Évaluation des habitudes et de la qualité du sommeil', 3, 'SLEEP', 2, 10, TRUE),
('Motivation et Objectifs', 'Questionnaire sur la motivation et la définition d''objectifs', 2, 'MOTIVATION', 2, 15, TRUE);

-- ============================================
-- QCM 6: Échelle d'Estime de Soi (10 questions)
-- ============================================

INSERT INTO qcm_question (qcm_id, position, question_text, question_type, options, weight) VALUES

(6, 1, 'Je pense que je suis une personne de valeur', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Tout à fait d''accord", "points": 10},
   {"value": "B", "text": "D''accord", "points": 7},
   {"value": "C", "text": "Neutre", "points": 5},
   {"value": "D", "text": "Pas d''accord", "points": 2},
   {"value": "E", "text": "Pas du tout d''accord", "points": 0}
 ]}', 1.0),

(6, 2, 'Je pense que j''ai un certain nombre de qualités', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Tout à fait d''accord", "points": 10},
   {"value": "B", "text": "D''accord", "points": 7},
   {"value": "C", "text": "Neutre", "points": 5},
   {"value": "D", "text": "Pas d''accord", "points": 2},
   {"value": "E", "text": "Pas du tout d''accord", "points": 0}
 ]}', 1.0),

(6, 3, 'Je pense que je suis capable de faire les choses aussi bien que les autres', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Tout à fait d''accord", "points": 10},
   {"value": "B", "text": "D''accord", "points": 7},
   {"value": "C", "text": "Neutre", "points": 5},
   {"value": "D", "text": "Pas d''accord", "points": 2},
   {"value": "E", "text": "Pas du tout d''accord", "points": 0}
 ]}', 1.0),

(6, 4, 'J''ai une attitude positive envers moi-même', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Tout à fait d''accord", "points": 10},
   {"value": "B", "text": "D''accord", "points": 7},
   {"value": "C", "text": "Neutre", "points": 5},
   {"value": "D", "text": "Pas d''accord", "points": 2},
   {"value": "E", "text": "Pas du tout d''accord", "points": 0}
 ]}', 1.0),

(6, 5, 'Je suis satisfait(e) de moi', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Tout à fait d''accord", "points": 10},
   {"value": "B", "text": "D''accord", "points": 7},
   {"value": "C", "text": "Neutre", "points": 5},
   {"value": "D", "text": "Pas d''accord", "points": 2},
   {"value": "E", "text": "Pas du tout d''accord", "points": 0}
 ]}', 1.0),

(6, 6, 'Je sens que je n''ai pas grand-chose dont je puisse être fier/fière', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Pas du tout d''accord", "points": 10},
   {"value": "B", "text": "Pas d''accord", "points": 7},
   {"value": "C", "text": "Neutre", "points": 5},
   {"value": "D", "text": "D''accord", "points": 2},
   {"value": "E", "text": "Tout à fait d''accord", "points": 0}
 ]}', 1.0),

(6, 7, 'Je me sens parfois inutile', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Jamais", "points": 10},
   {"value": "B", "text": "Rarement", "points": 7},
   {"value": "C", "text": "Parfois", "points": 5},
   {"value": "D", "text": "Souvent", "points": 2},
   {"value": "E", "text": "Toujours", "points": 0}
 ]}', 1.0),

(6, 8, 'J''aimerais avoir plus de respect pour moi-même', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Pas du tout d''accord", "points": 10},
   {"value": "B", "text": "Pas d''accord", "points": 7},
   {"value": "C", "text": "Neutre", "points": 5},
   {"value": "D", "text": "D''accord", "points": 2},
   {"value": "E", "text": "Tout à fait d''accord", "points": 0}
 ]}', 1.0),

(6, 9, 'Je me considère comme un(e) raté(e)', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Pas du tout d''accord", "points": 10},
   {"value": "B", "text": "Pas d''accord", "points": 7},
   {"value": "C", "text": "Neutre", "points": 5},
   {"value": "D", "text": "D''accord", "points": 2},
   {"value": "E", "text": "Tout à fait d''accord", "points": 0}
 ]}', 1.0),

(6, 10, 'Je pense que je vaux au moins autant que les autres', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Tout à fait d''accord", "points": 10},
   {"value": "B", "text": "D''accord", "points": 7},
   {"value": "C", "text": "Neutre", "points": 5},
   {"value": "D", "text": "Pas d''accord", "points": 2},
   {"value": "E", "text": "Pas du tout d''accord", "points": 0}
 ]}', 1.0);

-- ============================================
-- QCM 7: Test de Résilience Psychologique (10 questions)
-- ============================================

INSERT INTO qcm_question (qcm_id, position, question_text, question_type, options, weight) VALUES

(7, 1, 'Je parviens généralement à m''adapter aux changements', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Tout à fait vrai", "points": 10},
   {"value": "B", "text": "Souvent vrai", "points": 7},
   {"value": "C", "text": "Parfois vrai", "points": 5},
   {"value": "D", "text": "Rarement vrai", "points": 2},
   {"value": "E", "text": "Jamais vrai", "points": 0}
 ]}', 1.0),

(7, 2, 'Je trouve des moyens de gérer les situations difficiles', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Tout à fait vrai", "points": 10},
   {"value": "B", "text": "Souvent vrai", "points": 7},
   {"value": "C", "text": "Parfois vrai", "points": 5},
   {"value": "D", "text": "Rarement vrai", "points": 2},
   {"value": "E", "text": "Jamais vrai", "points": 0}
 ]}', 1.0),

(7, 3, 'Quand les choses semblent sans espoir, je n''abandonne pas', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Tout à fait vrai", "points": 10},
   {"value": "B", "text": "Souvent vrai", "points": 7},
   {"value": "C", "text": "Parfois vrai", "points": 5},
   {"value": "D", "text": "Rarement vrai", "points": 2},
   {"value": "E", "text": "Jamais vrai", "points": 0}
 ]}', 1.0),

(7, 4, 'Je garde mon calme sous pression', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Tout à fait vrai", "points": 10},
   {"value": "B", "text": "Souvent vrai", "points": 7},
   {"value": "C", "text": "Parfois vrai", "points": 5},
   {"value": "D", "text": "Rarement vrai", "points": 2},
   {"value": "E", "text": "Jamais vrai", "points": 0}
 ]}', 1.0),

(7, 5, 'Je vois le côté positif des choses', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Tout à fait vrai", "points": 10},
   {"value": "B", "text": "Souvent vrai", "points": 7},
   {"value": "C", "text": "Parfois vrai", "points": 5},
   {"value": "D", "text": "Rarement vrai", "points": 2},
   {"value": "E", "text": "Jamais vrai", "points": 0}
 ]}', 1.0),

(7, 6, 'Après une épreuve, je rebondis facilement', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Tout à fait vrai", "points": 10},
   {"value": "B", "text": "Souvent vrai", "points": 7},
   {"value": "C", "text": "Parfois vrai", "points": 5},
   {"value": "D", "text": "Rarement vrai", "points": 2},
   {"value": "E", "text": "Jamais vrai", "points": 0}
 ]}', 1.0),

(7, 7, 'J''ai confiance en ma capacité à résoudre des problèmes', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Tout à fait confiance", "points": 10},
   {"value": "B", "text": "Confiance", "points": 7},
   {"value": "C", "text": "Confiance moyenne", "points": 5},
   {"value": "D", "text": "Peu confiance", "points": 2},
   {"value": "E", "text": "Aucune confiance", "points": 0}
 ]}', 1.0),

(7, 8, 'Je tire des leçons de mes échecs', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Toujours", "points": 10},
   {"value": "B", "text": "Souvent", "points": 7},
   {"value": "C", "text": "Parfois", "points": 5},
   {"value": "D", "text": "Rarement", "points": 2},
   {"value": "E", "text": "Jamais", "points": 0}
 ]}', 1.0),

(7, 9, 'Je demande de l''aide quand j''en ai besoin', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Facilement", "points": 10},
   {"value": "B", "text": "Assez facilement", "points": 7},
   {"value": "C", "text": "Avec difficulté", "points": 5},
   {"value": "D", "text": "Très difficilement", "points": 2},
   {"value": "E", "text": "Je ne demande jamais", "points": 0}
 ]}', 1.0),

(7, 10, 'Je crois pouvoir atteindre mes objectifs malgré les obstacles', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Tout à fait", "points": 10},
   {"value": "B", "text": "Probablement", "points": 7},
   {"value": "C", "text": "Peut-être", "points": 5},
   {"value": "D", "text": "Probablement pas", "points": 2},
   {"value": "E", "text": "Pas du tout", "points": 0}
 ]}', 1.0);

-- ============================================
-- QCM 8: Évaluation du Soutien Social (10 questions)
-- ============================================

INSERT INTO qcm_question (qcm_id, position, question_text, question_type, options, weight) VALUES

(8, 1, 'Avez-vous des amis ou de la famille sur qui compter ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Oui, beaucoup", "points": 10},
   {"value": "B", "text": "Oui, quelques-uns", "points": 7},
   {"value": "C", "text": "Quelques personnes", "points": 5},
   {"value": "D", "text": "Très peu", "points": 2},
   {"value": "E", "text": "Personne", "points": 0}
 ]}', 1.0),

(8, 2, 'Pouvez-vous parler de vos problèmes avec quelqu''un ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Toujours", "points": 10},
   {"value": "B", "text": "Souvent", "points": 7},
   {"value": "C", "text": "Parfois", "points": 5},
   {"value": "D", "text": "Rarement", "points": 2},
   {"value": "E", "text": "Jamais", "points": 0}
 ]}', 1.0),

(8, 3, 'Vous sentez-vous entouré(e) et soutenu(e) ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Très soutenu", "points": 10},
   {"value": "B", "text": "Soutenu", "points": 7},
   {"value": "C", "text": "Moyennement soutenu", "points": 5},
   {"value": "D", "text": "Peu soutenu", "points": 2},
   {"value": "E", "text": "Pas du tout soutenu", "points": 0}
 ]}', 1.0),

(8, 4, 'Avez-vous quelqu''un qui vous écoute vraiment ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Oui, plusieurs personnes", "points": 10},
   {"value": "B", "text": "Oui, quelques personnes", "points": 7},
   {"value": "C", "text": "Oui, une personne", "points": 5},
   {"value": "D", "text": "Presque personne", "points": 2},
   {"value": "E", "text": "Personne", "points": 0}
 ]}', 1.0),

(8, 5, 'Participez-vous à des activités sociales ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Régulièrement", "points": 10},
   {"value": "B", "text": "Souvent", "points": 7},
   {"value": "C", "text": "Parfois", "points": 5},
   {"value": "D", "text": "Rarement", "points": 2},
   {"value": "E", "text": "Jamais", "points": 0}
 ]}', 1.0),

(8, 6, 'Vous sentez-vous seul(e) ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Jamais", "points": 10},
   {"value": "B", "text": "Rarement", "points": 7},
   {"value": "C", "text": "Parfois", "points": 5},
   {"value": "D", "text": "Souvent", "points": 2},
   {"value": "E", "text": "Toujours", "points": 0}
 ]}', 1.0),

(8, 7, 'Avez-vous reçu de l''aide pratique quand vous en aviez besoin ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Toujours", "points": 10},
   {"value": "B", "text": "Souvent", "points": 7},
   {"value": "C", "text": "Parfois", "points": 5},
   {"value": "D", "text": "Rarement", "points": 2},
   {"value": "E", "text": "Jamais", "points": 0}
 ]}', 1.0),

(8, 8, 'Êtes-vous satisfait(e) de vos relations sociales ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Très satisfait", "points": 10},
   {"value": "B", "text": "Satisfait", "points": 7},
   {"value": "C", "text": "Moyennement satisfait", "points": 5},
   {"value": "D", "text": "Insatisfait", "points": 2},
   {"value": "E", "text": "Très insatisfait", "points": 0}
 ]}', 1.0),

(8, 9, 'Faites-vous partie d''un groupe ou d''une communauté ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Oui, activement", "points": 10},
   {"value": "B", "text": "Oui, modérément", "points": 7},
   {"value": "C", "text": "Un peu", "points": 5},
   {"value": "D", "text": "Pas vraiment", "points": 2},
   {"value": "E", "text": "Pas du tout", "points": 0}
 ]}', 1.0),

(8, 10, 'Avez-vous quelqu''un qui vous encourage dans vos projets ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Oui, plusieurs personnes", "points": 10},
   {"value": "B", "text": "Oui, quelques personnes", "points": 7},
   {"value": "C", "text": "Oui, une personne", "points": 5},
   {"value": "D", "text": "Presque personne", "points": 2},
   {"value": "E", "text": "Personne", "points": 0}
 ]}', 1.0);

-- ============================================
-- QCM 9: Qualité du Sommeil (10 questions)
-- ============================================

INSERT INTO qcm_question (qcm_id, position, question_text, question_type, options, weight) VALUES

(9, 1, 'Combien de temps vous faut-il pour vous endormir ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Moins de 15 minutes", "points": 10},
   {"value": "B", "text": "15-30 minutes", "points": 7},
   {"value": "C", "text": "30-60 minutes", "points": 5},
   {"value": "D", "text": "1-2 heures", "points": 2},
   {"value": "E", "text": "Plus de 2 heures", "points": 0}
 ]}', 1.0),

(9, 2, 'Combien d''heures dormez-vous par nuit en moyenne ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "7-9 heures", "points": 10},
   {"value": "B", "text": "6-7 heures", "points": 7},
   {"value": "C", "text": "5-6 heures", "points": 5},
   {"value": "D", "text": "4-5 heures", "points": 2},
   {"value": "E", "text": "Moins de 4 heures", "points": 0}
 ]}', 1.0),

(9, 3, 'Vous réveillez-vous pendant la nuit ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Jamais", "points": 10},
   {"value": "B", "text": "Rarement (1 fois)", "points": 7},
   {"value": "C", "text": "Parfois (2 fois)", "points": 5},
   {"value": "D", "text": "Souvent (3+ fois)", "points": 2},
   {"value": "E", "text": "Très souvent (5+ fois)", "points": 0}
 ]}', 1.0),

(9, 4, 'Comment vous sentez-vous au réveil ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Reposé et énergique", "points": 10},
   {"value": "B", "text": "Plutôt reposé", "points": 7},
   {"value": "C", "text": "Un peu fatigué", "points": 5},
   {"value": "D", "text": "Fatigué", "points": 2},
   {"value": "E", "text": "Épuisé", "points": 0}
 ]}', 1.0),

(9, 5, 'Avez-vous des difficultés à rester éveillé(e) pendant la journée ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Jamais", "points": 10},
   {"value": "B", "text": "Rarement", "points": 7},
   {"value": "C", "text": "Parfois", "points": 5},
   {"value": "D", "text": "Souvent", "points": 2},
   {"value": "E", "text":"Très souvent", "points": 0}
 ]}', 1.0),

(9, 6, 'Utilisez-vous des aides au sommeil (médicaments, etc.) ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Jamais", "points": 10},
   {"value": "B", "text": "Très rarement", "points": 7},
   {"value": "C", "text": "Parfois", "points": 5},
   {"value": "D", "text": "Souvent", "points": 2},
   {"value": "E", "text": "Toutes les nuits", "points": 0}
 ]}', 1.0),

(9, 7, 'Votre sommeil est-il réparateur ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Très réparateur", "points": 10},
   {"value": "B", "text": "Réparateur", "points": 7},
   {"value": "C", "text": "Moyennement", "points": 5},
   {"value": "D", "text": "Peu réparateur", "points": 2},
   {"value": "E", "text": "Pas du tout réparateur", "points": 0}
 ]}', 1.0),

(9, 8, 'Faites-vous des cauchemars ou avez-vous un sommeil agité ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Jamais", "points": 10},
   {"value": "B", "text": "Rarement", "points": 7},
   {"value": "C", "text": "Parfois", "points": 5},
   {"value": "D", "text": "Souvent", "points": 2},
   {"value": "E", "text": "Très souvent", "points": 0}
 ]}', 1.0),

(9, 9, 'Avez-vous une routine de sommeil régulière ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Oui, très régulière", "points": 10},
   {"value": "B", "text": "Oui, assez régulière", "points": 7},
   {"value": "C", "text": "Moyennement régulière", "points": 5},
   {"value": "D", "text": "Peu régulière", "points": 2},
   {"value": "E", "text": "Pas du tout régulière", "points": 0}
 ]}', 1.0),

(9, 10, 'Votre environnement de sommeil est-il confortable ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Très confortable", "points": 10},
   {"value": "B", "text": "Confortable", "points": 7},
   {"value": "C", "text": "Moyennement confortable", "points": 5},
   {"value": "D", "text": "Peu confortable", "points": 2},
   {"value": "E", "text": "Inconfortable", "points": 0}
 ]}', 1.0);

-- ============================================
-- QCM 10: Motivation et Objectifs (10 questions)
-- ============================================

INSERT INTO qcm_question (qcm_id, position, question_text, question_type, options, weight) VALUES

(10, 1, 'Avez-vous des objectifs clairs pour votre rétablissement ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Oui, très clairs", "points": 10},
   {"value": "B", "text": "Oui, assez clairs", "points": 7},
   {"value": "C", "text": "Quelques objectifs", "points": 5},
   {"value": "D", "text": "Objectifs vagues", "points": 2},
   {"value": "E", "text": "Aucun objectif", "points": 0}
 ]}', 1.0),

(10, 2, 'Vous sentez-vous motivé(e) à travailler sur votre bien-être ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Très motivé", "points": 10},
   {"value": "B", "text": "Motivé", "points": 7},
   {"value": "C", "text": "Moyennement motivé", "points": 5},
   {"value": "D", "text": "Peu motivé", "points": 2},
   {"value": "E", "text": "Pas du tout motivé", "points": 0}
 ]}', 1.0),

(10, 3, 'Parvenez-vous à suivre vos progr ès ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Oui, régulièrement", "points": 10},
   {"value": "B", "text": "Oui, parfois", "points": 7},
   {"value": "C", "text": "Rarement", "points": 5},
   {"value": "D", "text": "Très rarement", "points": 2},
   {"value": "E", "text": "Jamais", "points": 0}
 ]}', 1.0),

(10, 4, 'Croyez-vous que vos efforts porteront leurs fruits ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Tout à fait", "points": 10},
   {"value": "B", "text": "Probablement", "points": 7},
   {"value": "C", "text": "Peut-être", "points": 5},
   {"value": "D", "text": "Probablement pas", "points": 2},
   {"value": "E", "text": "Pas du tout", "points": 0}
 ]}', 1.0),

(10, 5, 'Vous fixez-vous des objectifs réalistes ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Toujours", "points": 10},
   {"value": "B", "text": "Souvent", "points": 7},
   {"value": "C", "text": "Parfois", "points": 5},
   {"value": "D", "text": "Rarement", "points": 2},
   {"value": "E", "text": "Jamais", "points": 0}
 ]}', 1.0),

(10, 6, 'Célébrez-vous vos petites victoires ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Toujours", "points": 10},
   {"value": "B", "text": "Souvent", "points": 7},
   {"value": "C", "text": "Parfois", "points": 5},
   {"value": "D", "text": "Rarement", "points": 2},
   {"value": "E", "text": "Jamais", "points": 0}
 ]}', 1.0),

(10, 7, 'Persévérez-vous face aux obstacles ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Toujours", "points": 10},
   {"value": "B", "text": "Souvent", "points": 7},
   {"value": "C", "text": "Parfois", "points": 5},
   {"value": "D", "text": "Rarement", "points": 2},
   {"value": "E", "text": "Jamais", "points": 0}
 ]}', 1.0),

(10, 8, 'Avez-vous un plan d''action pour atteindre vos objectifs ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Oui, détaillé", "points": 10},
   {"value": "B", "text": "Oui, général", "points": 7},
   {"value": "C", "text": "Plan vague", "points": 5},
   {"value": "D", "text": "Plan très vague", "points": 2},
   {"value": "E", "text": "Aucun plan", "points": 0}
 ]}', 1.0),

(10, 9, 'Vous sentez-vous capable d''atteindre vos objectifs ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Tout à fait capable", "points": 10},
   {"value": "B", "text": "Généralement capable", "points": 7},
   {"value": "C", "text": "Moyennement capable", "points": 5},
   {"value": "D", "text": "Peu capable", "points": 2},
   {"value": "E", "text": "Incapable", "points": 0}
 ]}', 1.0),

(10, 10, 'Avez-vous le soutien nécessaire pour atteindre vos objectifs ?', 'SINGLE_CHOICE',
 '{"options": [
   {"value": "A", "text": "Oui, pleinement", "points": 10},
   {"value": "B", "text": "Oui, suffisamment", "points": 7},
   {"value": "C", "text": "Un peu", "points": 5},
   {"value": "D", "text": "Très peu", "points": 2},
   {"value": "E", "text": "Aucun soutien", "points": 0}
 ]}', 1.0);

-- Verify all questions
SELECT qcm_id, COUNT(*) as question_count 
FROM qcm_question 
GROUP BY qcm_id 
ORDER BY qcm_id;
