allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
        afterEvaluate {
        val project = this // 'this' refers to the Project

        if (project.plugins.hasPlugin("com.android.application") || project.plugins.hasPlugin("com.android.library")) {
            val androidExtension =
                project.extensions.getByName("android") as? com.android.build.gradle.LibraryExtension
                    ?: project.extensions.getByName("android") as? com.android.build.gradle.AppExtension

            androidExtension?.apply {
                compileSdkVersion(35)
                buildToolsVersion = "35.0.0"
            }
        }

        if (project.extensions.findByName("android") != null) {
            val androidExtension =
                project.extensions.getByName("android") as? com.android.build.gradle.LibraryExtension
                    ?: project.extensions.getByName("android") as? com.android.build.gradle.AppExtension

            androidExtension?.apply {
                if (namespace == null) {
                    namespace = project.group.toString()
                }
            }
        }
    }
    // ============
    buildDir = file("${rootProject.buildDir}/${project.name}")
    evaluationDependsOn(":app")
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

