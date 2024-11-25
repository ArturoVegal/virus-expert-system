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
    Age > 70,  % Ensure Age is above 70
    !.  % Cut to prevent further backtracking

% High-risk if male gender
risk_factor(Person, gender_male):-
    bio_data(Person, Gender, _),
    Gender = male,  % Explicitly check Gender = male
    !.  % Cut to prevent further backtracking

% Rule: Recent exposure 
% Checks if exposure is within 1–14 days
recent_exposure(Person):-
    exposure(Person, Type, DaysAgo),
    (
        Type = proximity_to_infected_person;  % Direct exposure is always considered
        (Type = contact_with_surface, DaysAgo =< 7)  % Indirect exposure only if very recent
    ),
    DaysAgo >= 1,
    DaysAgo =< 14.

% Indirect exposure: contact with surfaces
indirect_exposure(Person):-
    exposure(Person, Type, _),
    Type = contact_with_surface.

% Rule: Potential infection
% Likely infected based on exposure and symptoms
potential_infection(Person):-
    recent_exposure(Person),
    has_symptom(Person, fever),
    has_symptom(Person, persistent_dry_cough).
potential_infection(Person):-
    recent_exposure(Person),
    has_symptom(Person, difficulty_breathing).
potential_infection(Person):-
    recent_exposure(Person),
    has_high_risk(Person).

% Rule: Mild infection
% Fever and tiredness, no serious symptoms or risk
mild_infection(Person):-
    recent_exposure(Person),
    has_symptom(Person, fever),
    has_symptom(Person, tiredness),
    \+ has_serious_symptom(Person),
    \+ has_high_risk(Person).

% Rule: Moderate infection
% Fever, tiredness, and either aches or high risk
moderate_infection(Person):-
    (recent_exposure(Person); indirect_exposure(Person)),  % Include indirect exposure
    has_symptom(Person, fever),
    has_symptom(Person, tiredness),
    (
        has_symptom(Person, aches);
        has_high_risk(Person)
    ).

% Rule: Severe infection
% Serious symptoms or high risk with severe symptoms
severe_infection(Person):-
    recent_exposure(Person),
    has_serious_symptom(Person);
    (
        has_high_risk(Person),
        has_serious_symptom(Person)
    ).

% Rule: Asymptomatic infection
% Exposed but no symptoms
asymptomatic_infection(Person):-
    recent_exposure(Person),
    \+ has_symptom(Person, _).

% Rule: No infection
% Not exposed or symptomatic
no_infection(Person):-
    \+ potential_infection(Person),
    \+ mild_infection(Person),
    \+ moderate_infection(Person),
    \+ severe_infection(Person),
    \+ asymptomatic_infection(Person).

% Rule: Serious symptoms
% Checks for severe symptoms
has_serious_symptom(Person):-
    has_symptom(Person, Symptom),
    symptom(Symptom, serious).

% Rule: High-risk factors
% Combines age, gender, and health conditions
has_high_risk(Person):-
    risk_factor(Person, X),
    member(X, [age_over_70,hypertension,diabetes,cardiovascular_disease,chronic_respiratory_disease,cancer,gender_male]).

% Recommendations
% Suggests actions based on infection severity
recommendation(Person, immediate_medical_attention):-
    severe_infection(Person).
recommendation(Person, immediate_medical_attention):-
    has_high_risk(Person),
    has_serious_symptom(Person).

recommendation(Person, home_care):-
    mild_infection(Person).

recommendation(Person, home_recovery_with_attention):-
    moderate_infection(Person).

recommendation(Person, monitor_exposure):-
    asymptomatic_infection(Person).

recommendation(Person, no_action):-
    no_infection(Person).

% Bio-data
% Patient details: age and gender
bio_data(eline, female, 25). % Mild symptoms, not high-risk
bio_data(derk, male, 72).    % High-risk due to age
bio_data(nicole, female, 68). % Moderate risk, not high-risk due to age
bio_data(mia, female, 75).    % High-risk due to age
bio_data(luke, male, 35).     % No symptoms, not high-risk

% Symptoms for Test Patients
has_symptom(eline, fever).
has_symptom(eline, tiredness).

has_symptom(derk, fever).
has_symptom(derk, tiredness).
has_symptom(derk, aches).

has_symptom(nicole, difficulty_breathing).
has_symptom(nicole, chest_pain).

% Exposure facts
% Logs patient exposure details
exposure(eline, proximity_to_infected_person, 3). % Recent exposure
exposure(derk, contact_with_surface, 7).          % Slightly older exposure
exposure(nicole, proximity_to_infected_person, 12). % Recent exposure
exposure(mia, proximity_to_infected_person, 4).    % Recent exposure
exposure(luke, contact_with_surface, 10).         % No recent exposure