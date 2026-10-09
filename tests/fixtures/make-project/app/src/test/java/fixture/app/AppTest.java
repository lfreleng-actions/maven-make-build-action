// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Linux Foundation
package fixture.app;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class AppTest {
    @Test
    void messageGreetsThroughCore() {
        assertEquals("Hello, Maven!", App.message("Maven"));
        assertEquals("Hello, world!", App.message(" "));
    }
}
