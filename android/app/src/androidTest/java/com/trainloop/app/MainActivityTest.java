package com.trainloop.app;

import androidx.test.rule.ActivityTestRule;
import dev.flutter.plugins.integration_test.FlutterTestRunner;
import org.junit.Rule;
import org.junit.runner.RunWith;

/**
 * Corre los recorridos de integration_test/ como prueba instrumentada
 * (Firebase Test Lab, tool/test_lab.sh). El archivo Dart se elige al
 * compilar con -Ptarget=.
 */
@RunWith(FlutterTestRunner.class)
public class MainActivityTest {
  @Rule
  public ActivityTestRule<MainActivity> rule = new ActivityTestRule<>(MainActivity.class, true, false);
}
