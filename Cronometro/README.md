Questo progetto mostra un cronometro realizzato in Flutter utilizzando due Stream: uno genera un tick ogni 100 millisecondi, mentre l’altro ricava da questi tick il conteggio dei secondi. L’interfaccia visualizza il tempo nel formato MM:SS e include i pulsanti START/STOP, PAUSE/RESUME e RESET. I pulsanti si trovano al centro della schermata, sotto al tempo.

Il cronometro funziona in modo molto diretto. Quando parte, lo stream dei tick comincia a produrre valori; ogni dieci tick viene calcolato un secondo e aggiornato il display. Con STOP gli stream vengono fermati, con PAUSE il conteggio si sospende senza perderlo, mentre RESET riporta tutto a zero.

Per eseguire il progetto è sufficiente avere Flutter installato. Dopo aver scaricato il codice, si può avviare l’app con i comandi:

