## Testsuite Federation Master

#### Zielgruppe

Dieses Projekt richtet sich an Hersteller und Anbieter eines Federation Masters entsprechend *
gemSpec_IDP_FedMaster*. Es beinhaltet eine Testsuite, die prüft, ob bestimmte Schnittstellen
spezifikationskonform umgesetzt sind.

#### Konfiguration der Testsuite

Um die Testsuite einzusetzen, müssen zwei Dateien angepasst werden:

* in der ***tiger-template.yaml*** muss unter ***source*** die Adresse des Federation Masters
  eingetragen werden
* in der ***tc_properties-template.yaml*** müssen die Adressen des Fedmasters, eines Fachdienstes
  und
  eines IDPs der Föderation eingetragen werden (genau die Werte, die als **sub** beim Federation
  Fetch Endpoint zu verwenden sind).

#### Ausführung der Testsuite

Die Testsuite wird über das shell-Skript ***runTestsuite.sh*** ausgeführt. Sollen nur spezifische
Tests durchgeführt werden, kann das Skript angepasst und auf die gewünschten Cucumber-Tags gefiltert
werden.

#### Testergebnisse

Nach einer erfolgreichen Ausführung der Testsuite wird unter ```./target/site/serenity/index.html```
ein Testbericht erzeugt.
