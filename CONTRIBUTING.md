# Contributing to Svamparnas Värld

## Branching Strategy & Workflow

We follow a strict branching model to ensure stability in production.

- **`main`**: Production. Only deployed code lives here. **Do not push directly.**
- **`development`**: Integration. All features are merged here first.
- **`feature/*`**: Feature branches. Created from `development`.

### Workflow Steps

1. **Create Feature Branch**:
   ```bash
   git checkout development
   git pull
   git checkout -b feature/my-new-feature
   ```

2. **Develop & Test Locally**:
   Use the local Docker-based infrastructure to verify your changes.
   ```bash
   # Run the full integration test suite
   ./scripts/ci_local_test.sh
   ```

3. **Open Pull Request**:
   Push your branch and open a PR targeting `development`.
   The CI pipeline will run the integration tests automatically.

4. **Merge to Development**:
   Once approved and CI passes, merge into `development`.

5. **Release to Production**:
   When ready for a release, merge `development` into `main`.
   This triggers the automated deployment to the production environment.

## Code Standards
... (rest of the file)