/*
 * Copyright (Date see Readme), gematik GmbH
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
import static org.assertj.core.api.Assertions.assertThat;

import de.gematik.test.tiger.common.config.TigerGlobalConfiguration;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;

@Slf4j
class StepsGlueTest {

  @Test
  void checkReadPropertiesFromYaml_entryForSpecificKey() {
    final String pathInYaml = "fit.fedMasterUrl";
    assertThat(TigerGlobalConfiguration.readString(pathInYaml)).contains("http");
  }

  @Test
  void checkReadPropertiesFromYaml_keyNotFound() {
    final String valueButNotPathInYaml = "myValue";
    assertThat(TigerGlobalConfiguration.readString(valueButNotPathInYaml, valueButNotPathInYaml))
        .isEqualTo("myValue");
  }

  @Test
  void adaptUrlTest() {
    final String url = "https://idp-fedmaster-rpu.risedev.at/federation/list";
    assertThat(replaceHostForTiger(url)).isEqualTo("http://fedmaster/federation/list");
  }
}
