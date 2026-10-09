// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Linux Foundation
package fixture.core;

/** The library half of the fixture, which only app's test reaches. */
public final class Greeter {
    private Greeter() {
    }

    public static String greet(final String name) {
        if (name == null || name.isBlank()) {
            return "Hello, world";
        }
        return "Hello, " + name;
    }
}
