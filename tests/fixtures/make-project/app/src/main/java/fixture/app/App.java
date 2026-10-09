// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Linux Foundation
package fixture.app;

import fixture.core.Greeter;

/** Depends on core, so the reactor must build core first to compile. */
public final class App {
    private App() {
    }

    public static String message(final String name) {
        return Greeter.greet(name) + "!";
    }

    public static void main(final String[] args) {
        System.out.println(message(args.length > 0 ? args[0] : null));
    }
}
