#!/usr/bin/env node
// Skills auto-update hook - runs on SessionStart
import { execSync } from 'child_process';
try { execSync('skills update', { stdio: 'ignore', timeout: 30000 }); } catch {}
