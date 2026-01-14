Quiz Game – Applicazione Mobile Flutter
Descrizione del progetto

Questo progetto consiste nello sviluppo di un’applicazione mobile realizzata con il framework Flutter che implementa un gioco a quiz ispirato allo stile di Trivial Pursuit. L’applicazione consente all’utente di rispondere a una serie di domande a scelta multipla e di visualizzare il punteggio finale al termine della partita.

Il progetto rappresenta una base funzionale per la realizzazione di giochi mobile giocabili a distanza tra più utenti, come richiesto dalla consegna. La logica di gioco e l’interfaccia grafica sono già implementate e il sistema può essere esteso per supportare modalità multiplayer tramite connessione di rete.

Obiettivi della consegna

La consegna prevede la realizzazione di un gioco mobile tramite Flutter che consenta il gioco a distanza tra due utenti, includendo un server TCP incaricato della gestione dei turni e della logica interna del gioco, oltre a un client grafico mobile. Viene inoltre suggerito l’utilizzo di un database per giochi in stile Trivial Pursuit.

Questo progetto soddisfa parzialmente tali requisiti, concentrandosi sull’implementazione del client mobile e sulla logica del gioco, utilizzando un database di domande remoto come alternativa valida per giochi a quiz.

Funzionamento dell’applicazione

All’avvio dell’applicazione viene mostrata una schermata iniziale dalla quale è possibile avviare una nuova partita. Durante il quiz vengono presentate dieci domande a scelta multipla, caricate dinamicamente tramite una richiesta HTTP a un database online. Per ogni domanda l’utente seleziona una risposta e il sistema verifica automaticamente la correttezza, aggiornando il punteggio.

Al termine delle domande viene mostrata una schermata finale che riporta il punteggio totale ottenuto, con la possibilità di rigiocare o tornare alla schermata principale.

Tecnologie utilizzate

L’applicazione è sviluppata in Dart utilizzando il framework Flutter. Per il recupero delle domande viene utilizzato il package http, mentre come sorgente dati viene impiegata l’API pubblica OpenTriviaDB.

API delle domande

Le domande vengono recuperate tramite una richiesta HTTP GET all’endpoint di OpenTriviaDB che restituisce dieci domande a scelta multipla. Ogni domanda include il testo, la risposta corretta e le risposte errate, che vengono mescolate prima della visualizzazione.

Limiti attuali del progetto

Attualmente l’applicazione supporta solo la modalità single-player e non prevede comunicazione tra utenti. Non è presente un server TCP per la gestione delle partite, né un sistema di turni o un database proprietario per la persistenza dei dati.
