% Suppress discontiguous warnings
:- discontiguous risk_factor/2.
:- discontiguous has_symptom/2.
:- discontiguous exposure/3.
:- discontiguous bio_data/3.

% Common symptoms
symptom(fever, common).
symptom(persistent_dry_cough, common).
symptom(tiredness, common).

% Less common symptoms
symptom(aches, less_common).
symptom(pains, less_common).
symptom(sore_throat, less_common).
symptom(diarrhea, less_common).
symptom(conjunctivitis, less_common).
symptom(headache, less_common).
symptom(anosmia, less_common).
symptom(runny_nose, less_common).

% Serious symptoms
symptom(difficulty_breathing, serious).
symptom(chest_pain, serious).
symptom(loss_of_speech, serious).

% Risk factors derived from bio-data
risk_factor(Person, age_over_70):-
    bio_data(Person, _, Age), 
    Age > 70.

risk_factor(Person, gender_male):-
    bio_data(Person, male, _).

% Rule: Recent exposure (1–14 days)
recent_exposure(Person):-
    exposure(Person, _, DaysAgo),
    DaysAgo >= 1,
    DaysAgo =< 14.

% Rule: Potential infection
potential_infection(Person):-
    recent_exposure(Person),
    (
        (has_symptom(Person, fever), has_symptom(Person, persistent_dry_cough));
        has_symptom(Person, difficulty_breathing);
        has_high_risk(Person)
    ).

% Rule: Mild infection
mild_infection(Person):-
    recent_exposure(Person),
    has_symptom(Person, fever),
    has_symptom(Person, tiredness),
    \+ has_serious_symptom(Person),
    \+ has_high_risk(Person).

% Rule: Moderate infection
moderate_infection(Person):-
    recent_exposure(Person),
    has_symptom(Person, fever),
    has_symptom(Person, tiredness),
    (
        has_symptom(Person, aches);
        has_high_risk(Person)
    ).

% Rule: Severe infection
severe_infection(Person):-
    recent_exposure(Person),
    has_serious_symptom(Person);
    (
        has_high_risk(Person),
        has_serious_symptom(Person)
    ).

% Rule: Asymptomatic but potentially infectious
asymptomatic_infection(Person):-
    recent_exposure(Person),
    \+ has_symptom(Person, _).

% Rule: No infection
no_infection(Person):-
    \+ potential_infection(Person),
    \+ mild_infection(Person),
    \+ moderate_infection(Person),
    \+ severe_infection(Person),
    \+ asymptomatic_infection(Person).

% Rule: Serious symptoms
has_serious_symptom(Person):-
    has_symptom(Person, Symptom),
    writeln(debug:Symptom),  % Print each symptom being checked.
    symptom(Symptom, serious).

% Rule: High-risk factors
has_high_risk(Person):-
    risk_factor(Person, age_over_70);
    risk_factor(Person, hypertension);
    risk_factor(Person, diabetes);
    risk_factor(Person, cardiovascular_disease);
    risk_factor(Person, chronic_respiratory_disease);
    risk_factor(Person, cancer);
    risk_factor(Person, gender_male).

% Recommendations based on infection type
recommendation(Person, immediate_medical_attention):-
    severe_infection(Person);
    (has_high_risk(Person), has_serious_symptom(Person)).

recommendation(Person, home_care):-
    mild_infection(Person).

recommendation(Person, home_recovery_with_attention):-
    moderate_infection(Person).

recommendation(Person, monitor_exposure):-
    asymptomatic_infection(Person).

recommendation(Person, no_action):-
    no_infection(Person).

% Bio-data: Defines age and gender for individuals
bio_data(Eline, female, 25). % Mild symptoms, not high-risk
bio_data(Derk, male, 72).    % High-risk due to age
bio_data(Nicole, female, 68). % Moderate risk, not high-risk due to age
bio_data(Mia, female, 75).    % High-risk due to age
bio_data(Luke, male, 35).     % No symptoms, not high-risk

% Symptoms for Test Patients
has_symptom(Eline, fever).
has_symptom(Eline, tiredness).

has_symptom(Derk, fever).
has_symptom(Derk, tiredness).
has_symptom(Derk, aches).

has_symptom(Nicole, difficulty_breathing).
has_symptom(Nicole, chest_pain).

% Exposure facts: Tracks recent interactions with infected persons or surfaces
exposure(Eline, proximity_to_infected_person, 3). % Recent exposure
exposure(Derk, contact_with_surface, 7).          % Slightly older exposure
exposure(Nicole, proximity_to_infected_person, 12). % Recent exposure
exposure(Mia, proximity_to_infected_person, 4).    % Recent exposure
exposure(Luke, contact_with_surface, 10).         % No recent exposure
