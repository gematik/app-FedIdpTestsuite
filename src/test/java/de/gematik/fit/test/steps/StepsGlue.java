/*
 * Copyright (Change Date see Readme), gematik GmbH
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * *******
 *
 * For additional notes and disclaimer from gematik and in case of changes by gematik find details in the "Readme" file.
 */

package de.gematik.fit.test.steps;

import static de.gematik.fit.test.steps.FedmasterSteps.replaceHostForTiger;
import static de.gematik.rbellogger.data.RbelElementAssertion.assertThat;

import de.gematik.rbellogger.data.RbelElement;
import de.gematik.test.tiger.common.config.TigerGlobalConfiguration;
import de.gematik.test.tiger.lib.TigerDirector;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import net.serenitybdd.annotations.Steps;

@Slf4j
public class StepsGlue {

  @Steps FedmasterSteps fedmasterSteps;

  @And("Fetch Fedmaster Entity statement")
  public void ifetchEntStmnt() {
    fedmasterSteps.fetchEntStmnt();
  }

  @When("Send Get Request to {string}")
  public void sendGetRequestTo(final String url) {
    fedmasterSteps.sendGetRequestTo(
        replaceHostForTiger(TigerGlobalConfiguration.resolvePlaceholders(url)), null);
  }

  @When("Send Get Request to {string} with")
  public void sendGetRequestTo(final String url, final DataTable params) {
    fedmasterSteps.sendGetRequestTo(
        replaceHostForTiger(TigerGlobalConfiguration.resolvePlaceholders(url)), params);
  }

  @And("Expect JWKS in last message and add its keys to truststore")
  public void findJwk() {
    assertThat(getLastMessage()).extractChildWithPath("$.body.body.jwks.keys.0").isNotNull();
  }

  @SneakyThrows
  @Then("Check signature of JWS in last message")
  public void checkSignature() {
    assertThat(getLastMessage())
        .extractChildWithPath("$.body.signature.isValid")
        .hasValueEqualTo(Boolean.TRUE);
    assertThat(getLastMessage())
        .extractChildWithPath("$.body.signature.verifiedUsing")
        .valueAsString()
        .get()
        .isIn("puk_fed_sig", "puk_fedmaster_sig");
  }

  private static RbelElement getLastMessage() {
    final List<RbelElement> rbelMessages =
        TigerDirector.getTigerTestEnvMgr().getLocalTigerProxyOrFail().getRbelMessagesList();
    return rbelMessages.getLast();
  }
}
